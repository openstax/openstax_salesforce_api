module Pardot
  module Objects
    module ListMemberships
      class ListMemberships
        def create(list_id, prospect_id, params = {})
          post "/do/create/list_id/#{list_id}/prospect_id/#{prospect_id}", params
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

  def self.client
    pardot_secrets = Rails.application.secrets.pardot
    @client ||= Pardot::Client.new pardot_secrets[:email], pardot_secrets[:password], pardot_secrets[:user_key]
  end

  def self.salesforce_to_prospect(salesforce_id)
    client.prospects.read_by_fid(salesforce_id)['id']
  rescue Pardot::ResponseError
    nil
  end
end
