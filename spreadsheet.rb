require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

require "uri"

class SpreadSheet
  attr_reader :rows

  OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
  APPLICATION_NAME = "Google Sheets API Ruby Quickstart".freeze
  CREDENTIALS_PATH = "credentials.json".freeze
  # The file token.yaml stores the user's access and refresh tokens, and is
  # created automatically when the authorization flow completes for the first
  # time.
  TOKEN_PATH = "token.yaml".freeze
  SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(CREDENTIALS_PATH),
        scope: SCOPE)

    authorizer
  end

  def initialize
    # Initialize the API
    service = Google::Apis::SheetsV4::SheetsService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # Prints the names and majors of students in a sample spreadsheet:
    # https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
    spreadsheet_id = "1jresLo5EUHkUnVqV7A49P7FSxeQUHoF218iVKL5pTlg"
    range = "Sheet1!A2:D"
    response = service.get_spreadsheet_values spreadsheet_id, range
    puts "No data found." if response.values.empty?
    @rows = []

    response.values.each do |row|
      row[0] = row[0].split(',').map { |l| l.strip.to_f }
      row[0] = { lat: row[0][0], lng: row[0][1] }
      unless row[3].nil?
        image_url = URI.parse(row[3])
        image_url.query = 'raw=1'
        row[3] = image_url
      end
      rows << row
    end
  end

end
