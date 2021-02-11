require 'pardot/pardot'

class Api::V1::ListsController < ApplicationController
  include Pardot
  before_action :pardot_client

  # /api/v1/lists/
  # returns all available public lists from Pardot
  def available_lists
    lists = List.all
    render json: lists.to_json
  end

  # /api/v1/lists/subscribe/<list_id>/<salesforce_id>
  def subscribe
    list_id = params[:list_id]
    salesforce_id = params[:salesforce_id]

    prospect_id = salesforce_to_prospect(salesforce_id)["id"]

    begin
      @client.list_memberships.create(list_id, prospect_id)
    rescue Pardot::ResponseError
      Rails.logger.info 'User already subscribed to list'
      return head :conflict
    end

    head :accepted

  end

  # /api/v1/lists/unsubscribe/<list_id>/<salesforce_id>
  def unsubscribe
    list_id = params[:list_id]
    salesforce_id = params[:salesforce_id]

    prospect_id = salesforce_to_prospect(salesforce_id)['id']

    suppress(NoMethodError) do
      @client.list_memberships.delete(list_id, prospect_id)
    end

    return head :accepted
  end

  protected

  def salesforce_to_prospect(salesforce_id)
    @prospect = @client.prospects.read_by_fid(salesforce_id)
  end
end
