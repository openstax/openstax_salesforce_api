class Api::V1::LeadsController < Api::V1::BaseController
  # routes for this controller have been commented out and tests removed until the API is needed
  # The API is not being used.

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
