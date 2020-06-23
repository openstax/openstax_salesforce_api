class Api::V1::SchoolsController < ApplicationController

  # GET /schools
  def index
    @schools = School.all
    render json: @schools
  end

  # GET /schools/:id
  def show
    @school = School.find(params[:id])
    render json: @school
  end
end
