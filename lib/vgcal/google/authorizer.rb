# frozen_string_literal: true

require 'googleauth'
require 'google/apis/calendar_v3'
require 'fileutils'

module Vgcal
  # Class for authentication of Google API
  class Authorizer
    def initialize
      @credentials_path = "#{Dir.home}/.vgcal/credentials.json"
      @token_path = "#{Dir.home}/.vgcal/token.yaml"
      @scope = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
    end

    def credentials
      credential = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(@credentials_path),
        scope: @scope
      )

      credential.fetch_access_token!
      credential
    end
  end
end
