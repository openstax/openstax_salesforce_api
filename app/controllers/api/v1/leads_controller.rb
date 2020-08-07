class Api::V1::LeadsController < ApplicationController

  # GET /leads
  def index
    @leads = Lead.paginate(page: params[:page], per_page: 20)
    render json: @leads
  end

  # GET /leads/:id
  def show
    begin
      @lead = Lead.where(salesforce_id: params[:id])
      render json: @lead, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
