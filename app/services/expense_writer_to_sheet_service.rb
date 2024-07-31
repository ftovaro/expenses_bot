require 'google/apis/sheets_v4'
require 'googleauth'
require 'logger'

class ExpenseWriterToSheetService
  def initialize(expense)
    @expense = expense
    @logger = Logger.new(STDOUT)
  end

  def call
    write_to_sheet
  end

  private

  def write_to_sheet
    service = GoogleSheetsService.new
    spreadsheet_id = ENV['SPREADSHEET_ID']
    sheet_name = Date.today.strftime("%B") # Gets the current month name, e.g., 'July'
    @logger.info "Checking existence of sheet: #{sheet_name}"
    sheet_id = find_or_create_sheet(service, spreadsheet_id, sheet_name)

    range, format_range = determine_range_and_format_range(sheet_name, sheet_id)

    # Prepare the data to write
    values = [@expense.id, @expense.amount, @expense.description, @expense.timestamp.strftime("%Y-%m-%d")]
    @logger.info "Writing data to range: #{range}, values: #{values}"

    service.write_to_sheet(spreadsheet_id, range, values)
    { message: 'Successfully written to Google Sheets.', status: :ok }
  rescue => e
    @logger.error "Error writing to Google Sheets: #{e.message}"
    { error: e.message, status: :unprocessable_entity }
  end

  def determine_range_and_format_range(sheet_name, sheet_id)
    row_number = find_next_available_row(sheet_name)
    if @expense.group == 1
      range = "#{sheet_name}!A#{row_number}:E#{row_number}"
      format_range = { start_row_index: row_number - 1, end_row_index: row_number, start_column_index: 1, end_column_index: 2, sheet_id: sheet_id }
    else
      range = "#{sheet_name}!G#{row_number}:K#{row_number}"
      format_range = { start_row_index: row_number - 1, end_row_index: row_number, start_column_index: 7, end_column_index: 8, sheet_id: sheet_id }
    end
    @logger.info "Determined range: #{range} and format range: #{format_range}"
    [range, format_range]
  end

  def find_next_available_row(sheet_name)
    service = GoogleSheetsService.new
    spreadsheet_id = ENV['SPREADSHEET_ID']
    sheet = service.get_spreadsheet(spreadsheet_id).sheets.find { |s| s.properties.title&.downcase == sheet_name&.downcase }
    last_row = service.get_last_filled_row(spreadsheet_id, sheet_name)
    @logger.info "Last filled row in sheet '#{sheet_name}': #{last_row}"
    last_row + 1
  end

  def find_or_create_sheet(service, spreadsheet_id, sheet_name)
    spreadsheet = service.get_spreadsheet(spreadsheet_id)
    sheet = spreadsheet.sheets.find { |s| s.properties.title&.downcase == sheet_name&.downcase }

    return sheet.properties.sheet_id if sheet

    @logger.info "Creating new sheet: #{sheet_name}"
    new_sheet = Google::Apis::SheetsV4::Sheet.new(properties: { title: sheet_name })
    batch_update_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(
      requests: [{ add_sheet: { properties: { title: sheet_name } } }]
    )
    response = service.batch_update_spreadsheet(spreadsheet_id, batch_update_request)
    response.replies.first.add_sheet.properties.sheet_id
  end
end
