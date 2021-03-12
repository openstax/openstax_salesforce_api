# Eventually, this should be where we have code to talk directly to salesforce
# instead of using the openstax_salesforce gem.
# For now - this is just to get the salesforce client to interact with the pardot api

module Salesforce
  class Client
    def initialize
      salesforce_secrets = Rails.application.secrets.salesforce

      salesforce_client = Restforce.new(username: salesforce_secrets[:username],
                                        password: salesforce_secrets[:password],
                                        security_token: salesforce_secrets[:security_token],
                                        client_id: salesforce_secrets[:consumer_key],
                                        client_secret: salesforce_secrets[:consumer_secret],
                                        host: salesforce_secrets[:login_domain],
                                        api_version: '41.0')
      @client = salesforce_client.authenticate!
    end

    def access_token
      @client.access_token
    end
  end
end