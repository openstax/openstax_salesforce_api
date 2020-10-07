class Api::V1::CampaignMembersController < ApplicationController
  before_action :authorize_request

  # GET /campaign_members
  def index
    @campaign_members = CampaignMember.paginate(page: params[:page], per_page: 20)
    render json: @campaign_members
  end

  # GET /campaign_members/:id
  def show
    begin
      @campaign_member = CampaignMember.where(salesforce_id: params[:id])
      render json: @campaign_member, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
