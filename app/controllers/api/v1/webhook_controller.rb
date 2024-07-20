class Api::V1::WebhookController < ApiController
  def index
    render json: { message: 'Hello, World!' }, status: :ok
  end
end
