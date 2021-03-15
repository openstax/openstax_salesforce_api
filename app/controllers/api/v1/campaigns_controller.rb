class Api::V1::CampaignsController < Api::V1::BaseController
  # GET /campaigns
  def index
    @campaigns = Campaign.paginate(page: params[:page], per_page: 20)
    render json: @campaigns
  end

  # GET /campaigns/:id
  def show
    begin
      @campaign = Campaign.find(params[:id])
      render json: @campaign, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
