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
    @client ||= begin
        pardot_secrets = Rails.application.secrets.pardot
        salesforce_client = Salesforce::Client.new
        Pardot::Client.new nil, nil, nil, 4, salesforce_client.access_token, pardot_secrets[:business_unit_id]
      end
  end

  def self.salesforce_to_prospect(salesforce_id)
    client.prospects.read_by_fid(salesforce_id)['id']
  end

end
