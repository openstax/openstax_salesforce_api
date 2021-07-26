class Api::V1::LeadsController < Api::V1::BaseController
  # GET /leads
  def index
    head(:not_found)
  end

  # GET /leads/:id
  def show
    @lead = Lead.find_by!(salesforce_id: params[:id])
    render json: @lead, status: :ok
  end

  # GET /leads/search?os_accounts_id
  def search
    @lead = Lead.search(params[:os_accounts_id])
    render json: @lead, status: :ok
  end
end
