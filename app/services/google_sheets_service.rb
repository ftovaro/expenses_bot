class GoogleSheetsService
  APPLICATION_NAME = 'Expenses Bot'.freeze

  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def write_to_sheet(spreadsheet_id, range, values)
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: [values])
    @service.append_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: 'RAW')
  end

  def get_spreadsheet(spreadsheet_id)
    @service.get_spreadsheet(spreadsheet_id)
  end

  def batch_update_spreadsheet(spreadsheet_id, batch_update_request)
    @service.batch_update_spreadsheet(spreadsheet_id, batch_update_request)
  end

  def get_last_filled_row(spreadsheet_id, sheet_name)
    response = @service.get_spreadsheet_values(spreadsheet_id, "#{sheet_name}!A:A")
    response.values ? response.values.size : 0
  end

  private

  def authorize
    scope = 'https://www.googleapis.com/auth/spreadsheets'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV['GOOGLE_CREDENTIALS']),
      scope: scope
    )
    authorizer.fetch_access_token!
    authorizer
  end
end
