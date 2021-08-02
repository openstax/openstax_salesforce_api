class Api::V1::CampaignsController < Api::V1::BaseController
  # routes for this controller have been commented out and tests removed until the API is needed
  # The API is not being used.

  # GET /campaigns/:id
  def show
    @campaign = Campaign.find_by!(salesforce_id: params[:id])
    render json: @campaign
  end
end
