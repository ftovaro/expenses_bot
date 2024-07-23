class Api::V1::TestController < ApiController
  def index
    service = GoogleSheetsService.new
    spreadsheet_id = ENV['SPREADSHEET_ID']
    range = params[:range] || 'Sheet1!A1'
    value = params[:value] || 'Hello World!'

    begin
      service.write_to_sheet(spreadsheet_id, range, value)
      render json: { message: 'Successfully written to Google Sheets.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
