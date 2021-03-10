module Pardot
  module Objects
    module ListMemberships
      class ListMemberships
        def create(list_id, prospect_id, params = {})
          post "/do/create/list_id/#{list_id}/prospect_id/#{prospect_id}", params
        rescue Pardot::ResponseError => e
          case e.message
          when 'That prospect is already a member of that list. Update the membership instead.'
            nil
          else
            raise
          end
        end

        def delete(list_id, prospect_id, params = {})
          post "/do/delete/list_id/#{list_id}/prospect_id/#{prospect_id}", params
        end

        protected

        def post(path, params = {}, result = 'listMembership')
          response = @client.post 'listMembership', path, params
          if response
            result ? response[result] : response
          end
        end
      end
    end
  end

  class Client
    base_uri Rails.application.secrets.pardot[:login_url]
  end

  def self.client
    pardot_secrets = Rails.application.secrets.pardot
    salesforce_secrets = Rails.application.secrets.salesforce
    @username = salesforce_secrets[:username]
    @password = salesforce_secrets[:password]
    @security_token = salesforce_secrets[:security_token]
    @salesforce_login_domain = 'https://' + salesforce_secrets[:login_domain]

    @client_id = salesforce_secrets[:consumer_key]
    @client_secret = salesforce_secrets[:consumer_secret]
    @business_unit_id = pardot_secrets[:business_unit_id]

    parameters = {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret,
      username: @username,
      password: @password + @security_token
    }

    response = HTTParty.post(@salesforce_login_domain + '/services/oauth2/token', query: parameters)
    raise "Failed to contact Salesforce\n#{response.body}" if response.code != 200

    response_json_obj = JSON.parse response.body, symbolize_names: true
    access_token = response_json_obj[:access_token]

    @client ||= Pardot::Client.new nil, nil, nil, 4, access_token, @business_unit_id
  end

  def self.salesforce_to_prospect(salesforce_id)
    client.prospects.read_by_fid(salesforce_id)['id']
  end

end
