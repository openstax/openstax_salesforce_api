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

    attr_accessor :email, :password, :user_key, :api_key, :version, :format

    def initialize(email, password, user_key, version = 3)
      @email = email
      @password = password
      @user_key = user_key
      @version = version

      @format = "simple"
    end

  end
end
