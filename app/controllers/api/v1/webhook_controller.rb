class Api::V1::WebhookController < ApiController
  def verify
    token = 'HAPPY'
    if params.dig('hub.verify_token') == token
      return render plain: params.dig('hub.challenge')
    end

    render json: { message: 'Verification failed' }, status: :forbidden
  end

  def receive
    params_hash = convert_to_json_compatible(params.to_unsafe_h)

    WhatsappMessageParserJob.perform_async(params_hash)

    render json: { message: 'Message received' }
  end

  private

  def convert_to_json_compatible(value)
    case value
    when Hash
      value.each_with_object({}) { |(k, v), h| h[k.to_s] = convert_to_json_compatible(v) }
    when Array
      value.map { |v| convert_to_json_compatible(v) }
    else
      value
    end
  end
end
