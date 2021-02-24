module Pardot
  class Client
    include HTTParty
    base_uri 'https://pi.pardot.com'
    format :xml

    include Authentication
    include Http

    include Objects::Lists
    include Objects::ListMemberships
    include Objects::Prospects

    attr_accessor :version, :format

    def initialize(version = 3)
      pardot_secrets = Rails.application.secrets.pardot
      @email = pardot_secrets[:email]
      @password = pardot_secrets[:password]
      @user_key = pardot_secrets[:user_key]
      @version = version

      @format = 'simple'
    end

    def self.client
      return @client unless @client.nil?

      @client = self.new
      @client.authenticate
      @client
    end
  end
end
