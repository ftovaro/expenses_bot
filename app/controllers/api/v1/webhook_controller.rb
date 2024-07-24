class Api::V1::WebhookController < ApiController
  def verify
    # token = 'HAPPY'
    # if params.dig('hub.verify_token') == token
    #   return render plain: params.dig('hub.challenge')
    # end

    render json: { message: 'Verification failed' }, status: :forbidden
  end

  def receive
    # webhook_parser = WebhookParserService.new(params)
    # webhook_parser.call

    # if webhook_parser.message.present?
    #   message = webhook_parser.message
    #   ExpenseWriterToSheetService.new(message.expense).call
    # end

    render json: { message: 'Message received' }
  end
end
