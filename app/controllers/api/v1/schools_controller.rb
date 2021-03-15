class Api::V1::SchoolsController < Api::V1::BaseController
  # GET /schools?name=school-name
  def index
    @schools = if params['name'].present?
                 School.search(params['name'])
               else
                 School.paginate(page: params[:page], per_page: 20)
               end
    render json: @schools
  end

  # GET /schools/:id
  def show
    @school = School.find_by!(salesforce_id: params[:id])
    render json: @school, status: :ok
  end
end
