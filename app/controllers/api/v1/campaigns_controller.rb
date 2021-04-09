class Api::V1::CampaignsController < Api::V1::BaseController
  # GET /campaigns
  def index
    @campaigns = Campaign.paginate(page: params[:page], per_page: 20)
    render json: @campaigns
  end

  # GET /campaigns/:id
  def show
    @campaign = Campaign.find_by!(salesforce_id: params[:id])
    render json: @campaign, status: :ok
  end
end
