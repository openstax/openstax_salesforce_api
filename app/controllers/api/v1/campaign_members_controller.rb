class Api::V1::CampaignMembersController < Api::V1::BaseController
  # GET /campaign_members
  def index
    head(:not_found)
  end

  # GET /campaign_members/:id
  def show
    @campaign_member = CampaignMember.where(salesforce_id: params[:id])
    render json: @campaign_member, status: :ok
  end
end
