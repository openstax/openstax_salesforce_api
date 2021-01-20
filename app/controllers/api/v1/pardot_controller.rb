require 'pardot/pardot'

class Api::V1::PardotController < ApplicationController
  include Pardot
  before_action :pardot_client

  # /api/v1/lists/user/<salesforce_id>
  # returns public lists user is currently subscribed to
  def pardot_user
    @prospect = @client.prospects.read_by_fid(params[:salesforce_id]) # to get prospect by Salesforce id

    user_email_lists = []
    @prospect['lists']['list_subscription'].each do |list|
      if list['list']['is_public'] == 'true'
        user_email_lists.push({ id: list['list']['id'], title: list['list']['name'], description: list['list']['description'] })
      end
    end

    render json: user_email_lists.to_json
  end

  # /api/v1/lists/
  # returns all available public lists from Pardot
  def available_lists
    lists = @client.lists.query(:is_greater_than => 0)

    public_lists = []
    lists['list'].each do |list|
      if list['is_public'] == 'true'
        public_lists.push({ id: list['id'], title: list['title'], description: list['description'] })
      end
    end

    render json: public_lists.to_json
  end

  # /api/v1/lists/subscribe/<list_id>/<salesforce_id>
  def subscribe
    list_id = params[:list_id]
    salesforce_id = params[:salesforce_id]

    prospect_id = salesforce_to_prospect(salesforce_id)["id"]

    begin
      @client.list_memberships.create(list_id, prospect_id)
    rescue Pardot::ResponseError
      puts 'User already subscribed to list'
    end

    redirect_to controller: 'pardot', action: 'pardot_user', salesforce_id: salesforce_id
  end

  # /api/v1/lists/unsubscribe/<list_id>/<salesforce_id>
  def unsubscribe
    list_id = params[:list_id]
    salesforce_id = params[:salesforce_id]

    prospect_id = salesforce_to_prospect(salesforce_id)['id']

    suppress(NoMethodError) do
      @client.list_memberships.delete(list_id, prospect_id)
    end

    redirect_to controller: 'pardot', action: 'pardot_user', salesforce_id: salesforce_id
  end

  protected

  def pardot_client
    pardot_secrets = Rails.application.secrets.pardot
    @client = Pardot::Client.new pardot_secrets[:email], pardot_secrets[:password], pardot_secrets[:user_key]
    @client.authenticate
  end

  def salesforce_to_prospect(salesforce_id)
    @prospect = @client.prospects.read_by_fid(salesforce_id)
  end
end
