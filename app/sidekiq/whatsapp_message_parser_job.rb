class WhatsappMessageParserJob
  include Sidekiq::Job

  def perform(params)
    webhook_parser = WebhookParserService.new(params)
    webhook_parser.call

    message = Message.new(body: webhook_parser.body,
                          sender_name: webhook_parser.sender_name,
                          sender_phone: webhook_parser.sender_phone,
                          timestamp:  DateTime.strptime(webhook_parser.timestamp, '%s'))

    if message.valid?
      message.save!

      # TODO This is hardcoded and needs to be removed eventually
      group = 0
      phones = ENV['PHONE_NUMBERS'].split(',')
      group_1 = phones[0..1]
      group_2 = phones[2..3]

      if ['Felipe Tovar', 'Catalina Tabares'].include?(message.sender_name)
        to_numbers = group_1
        group = 1
      else
        to_numbers = group_2
        group = 2
      end

      ExpenseWriterToSheetService.new(message.expense, group).call

      WhatsappPaymentDone.new(ENV['WHATSAPP_ACCESS_TOKEN'], ENV['PHONE_ID']).call(
        message: message.expense.description,
        amount: message.expense.amount,
        timestamp: message.expense.timestamp.strftime("%d/%m/%Y"),
        id: message.expense.id,
        to_numbers: to_numbers
      )
    else
      Rails.logger.error("Message is invalid: #{message.errors.full_messages}")
    end
  end
end
