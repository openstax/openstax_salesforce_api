class Api::V1::LeadsController < Api::V1::BaseController
  # GET /leads
  def index
    @leads = Lead.paginate(page: params[:page], per_page: 20)
    render json: @leads
  end

  # GET /leads/:id
  def show
    @lead = Lead.find_by!(salesforce_id: params[:id])
    render json: @lead
  end

  # GET /leads/search?os_accounts_id
  def search
    @lead = Lead.search(params[:os_accounts_id])
    render json: @lead
  end
end
