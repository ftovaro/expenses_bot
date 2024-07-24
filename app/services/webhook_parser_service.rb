class WebhookParserService
  attr_reader :message, :sender_phone, :body, :timestamp

  def initialize(params)
    @params = params
    @message = nil
  end

  def call
    extract_data
  end

  private

  def extract_data
    sender_name = ""
    entries = @params['entry'] || []
    entries.each do |entry|
      changes = entry['changes'] || []
      changes.each do |change|
        value = change['value']
        contacts = value['contacts'] || []
        contacts.each do |contact|
          sender_name = contact.dig('profile', 'name') || "Unknown"
        end
        messages = value['messages'] || []
        messages.each do |message|
          store_message_data(message, sender_name)
        end
      end
    end
  end

  def store_message_data(message, sender_name)
    @sender_phone = message['from']
    @body = message.dig('text', 'body')
    @timestamp = message['timestamp']

    # @message = Message.create!(
    #   sender_name: sender_name,
    #   sender_phone: sender_phone,
    #   body: body,
    #   timestamp: Time.at(timestamp.to_i)
    # )
  end
end
