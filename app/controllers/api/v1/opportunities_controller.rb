class Api::V1::OpportunitiesController < ApplicationController

  # GET /opportunities
  def index
    @opportunities = Opportunity.paginate(page: params[:page], per_page: 20)
    render json: @opportunities
  end

  # GET /opportunities/:id
  def show
    begin
      @opportunity = Opportunity.where(salesforce_id: params[:id])
      render json: @opportunity, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
