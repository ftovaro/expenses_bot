class Api::V1::TestController < ApiController
  def index
    render json: { message: 'Hello, World!' }, status: :ok
  end
end
