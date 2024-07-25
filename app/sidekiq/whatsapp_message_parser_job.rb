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
      ExpenseWriterToSheetService.new(message.expense).call
    else
      Rails.logger.error("Message is invalid: #{message.errors.full_messages}")
    end
  end
end
