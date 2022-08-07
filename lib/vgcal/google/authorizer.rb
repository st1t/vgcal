# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/calendar_v3'
require 'fileutils'

module Vgcal
  # for Google authorization
  class Authorizer
    def initialize
      @oob_uri = 'urn:ietf:wg:oauth:2.0:oob'
      @credentials_path = "#{Dir.home}/.vgcal/credentials.json"
      @token_path = "#{Dir.home}/.vgcal/token.yaml"
      @scope = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
    end

    def credentials
      client_id = Google::Auth::ClientId.from_file @credentials_path
      token_store = Google::Auth::Stores::FileTokenStore.new file: @token_path
      authorizer = Google::Auth::UserAuthorizer.new client_id, @scope, token_store
      user_id = 'default'
      credentials = authorizer.get_credentials user_id
      if credentials.nil?
        url = authorizer.get_authorization_url base_url: @oob_uri
        puts "Open the following URL in the browser and enter the resulting code after authorization:\n#{url}"
        code = $stdin.gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: @oob_uri
        )
      end
      credentials
    end
  end
end
