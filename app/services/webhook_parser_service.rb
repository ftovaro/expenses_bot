class WebhookParserService
  def initialize(params)
    @params = params
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
    sender_phone = message['from']
    message_body = message.dig('text', 'body')
    timestamp = message['timestamp']

    Message.create!(
      sender_name: sender_name,
      sender_phone: sender_phone,
      message_body: message_body,
      timestamp: Time.at(timestamp.to_i)
    )
  end
end
