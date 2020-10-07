class Api::V1::SchoolsController < ApplicationController
  before_action :authorize_request

  # GET /schools
  def index
    @schools = School.paginate(page: params[:page], per_page: 20)
    render json: @schools
  end

  # GET /schools/:id
  def show
    begin
      @school = School.find(params[:id])
      render json: @school, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
