class Api::V1::SchoolsController < Api::V1::BaseController
  # GET /schools
  def index
    head(:not_found)
  end

  # GET /schools/:id
  def show
    @school = School.find_by!(salesforce_id: params[:id])
    render json: @school, status: :ok
  end

  # GET /schools/search?name='school'&limit=150
  def search
    @schools = School.search(params[:name], params[:limit])
    render json: @schools, status: :ok
  end
end
