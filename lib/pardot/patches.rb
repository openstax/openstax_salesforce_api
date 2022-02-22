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
    # we don't have pardot setup on all sandboxes, we can't setup the client for these environments
    warn('No pardot business unit id') && return if Rails.application.secrets.pardot[:business_unit_id]

    @client ||= begin
        pardot_secrets = Rails.application.secrets.pardot
        salesforce_client = OpenStax::Salesforce::Client.new
        salesforce_client_data = salesforce_client.authenticate!

        Pardot::Client.new nil, nil, nil, 4, salesforce_client_data[:access_token], pardot_secrets[:business_unit_id]
      end
  end

  def self.salesforce_to_prospect(salesforce_id)
    client.prospects.read_by_fid(salesforce_id)['id']
  rescue Pardot::ResponseError => e
    case e.message
    when 'Invalid prospect fid'
      raise CannotFindProspect
    end
  end

end
