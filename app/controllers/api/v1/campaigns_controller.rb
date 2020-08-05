class Api::V1::CampaignsController < ApplicationController

  # GET /books
  def index
    @campaigns = Campaign.paginate(page: params[:page], per_page: 20)
    render json: @campaigns
  end

  # GET /books/:id
  def show
    begin
      @campaign = Campaign.where(salesforce_id: params[:id])
      render json: @campaign, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
