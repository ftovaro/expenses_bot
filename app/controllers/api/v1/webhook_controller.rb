class Api::V1::WebhookController < ApiController
  def verify
    token = 'HAPPY'
    if params.dig('hub.verify_token') == token
      return render plain: params.dig('hub.challenge')
    end

    render json: { message: 'Verification failed' }, status: :forbidden
  end

  def receive
    render json: { message: 'Message received' }
  end
end
