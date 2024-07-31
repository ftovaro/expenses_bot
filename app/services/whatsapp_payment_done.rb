require 'httparty'

class WhatsappPaymentDone
  BASE_URI = 'https://graph.facebook.com/v20.0'.freeze

  def initialize(access_token, phone_id)
    @access_token = access_token
    @phone_id = phone_id
  end

  def call(message:, amount:, timestamp:, id:, to_numbers:)
    puts "Access Token: #{@access_token}"
    puts "Phone ID: #{@phone_id}"
    to_numbers.each do |number|
      send_message(message, amount, timestamp, id, number)
    end
  end

  private

  def send_message(message, amount, timestamp, id, to)
    url = "#{BASE_URI}/#{@phone_id}/messages"
    body = {
      messaging_product: 'whatsapp',
      to: to,
      type: 'template',
      template: {
        name: 'payment_done',
        language: {
          code: 'es'
        },
        components: [
          {
            type: 'body',
            parameters: [
              {
                type: 'text',
                text: message
              },
              {
                type: 'currency',
                currency: {
                  amount_1000: amount * 1000,
                  fallback_value: -1,
                  code: 'COP'
                }
              },
              {
                type: 'text',
                text: timestamp
              },
              {
                type: 'text',
                text: id.to_s
              }
            ]
          }
        ]
      }
    }.to_json

    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{@access_token}"
    }

    puts "Sending message to #{url}"
    puts "Request headers: #{headers}"
    puts "Request body: #{body}"

    response = HTTParty.post(
      url,
      headers: headers,
      body: body
    )

    handle_response(response)
  end

  def handle_response(response)
    if response.success?
      puts "Message sent successfully!"
    else
      puts "Error sending message: #{response.body}"
      puts "Response code: #{response.code}"
      puts "Response headers: #{response.headers.inspect}"
    end
  end
end
