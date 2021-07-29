class Api::V1::CampaignMembersController < Api::V1::BaseController
  # routes for this controller have been commented out and tests removed until the API is needed
  # The API is not being used.

  # GET /campaign_members/:id
  def show
    @campaign_member = CampaignMember.where(salesforce_id: params[:id])
    render json: @campaign_member, status: :ok
  end
end
