require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSheetsService
  APPLICATION_NAME = 'Expenses Bot'.freeze

  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def write_to_sheet(spreadsheet_id, range, value)
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: [[value]])
    @service.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: 'RAW')
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
