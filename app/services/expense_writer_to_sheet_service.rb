class ExpenseWriterToSheetService
  def initialize(expense)
    @expense = expense
  end

  def call
    write_to_sheet
  end

  private

  def write_to_sheet
    service = GoogleSheetsService.new
    spreadsheet_id = ENV['SPREADSHEET_ID']
    range = 'july!A1' || 'Sheet1!A1'
    value = 'value' || 'Hello World!'

    begin
      service.write_to_sheet(spreadsheet_id, range, value)
      { message: 'Successfully written to Google Sheets.', status: :ok }
    rescue => e
      { error: e.message, status: :unprocessable_entity }
    end
  end
end
