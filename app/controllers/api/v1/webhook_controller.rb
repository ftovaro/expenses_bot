class Api::V1::WebhookController < ApiController
  def verify
    token = 'HAPPY'
    if params.dig('hub.verify_token') == token
      return render json: { 'hub.challenge': params.dig('hub.challenge') }, status: :ok
    end

    render json: { message: 'Verification failed' }, status: :forbidden
  end

  def receive
    render json: { message: 'Message received' }
  end
end
