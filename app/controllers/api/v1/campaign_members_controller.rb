class Api::V1::CampaignMembersController < Api::V1::BaseController
  # GET /campaign_members
  def index
    @campaign_members = CampaignMember.paginate(page: params[:page], per_page: 20)
    render json: @campaign_members
  end

  # GET /campaign_members/:id
  def show
    @campaign_member = CampaignMember.where(salesforce_id: params[:id])
    render json: @campaign_member
  end
end
