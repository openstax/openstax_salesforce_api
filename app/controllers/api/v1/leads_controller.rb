class Api::V1::LeadsController < Api::V1::BaseController
  # GET /leads
  def index
    if params['os_accounts_id'].present?
      @leads = Lead.where(os_accounts_id: params['os_accounts_id'])
      if @leads.blank?
        render json: {
            os_accounts_id: params['os_accounts_id'],
            error: 'id not found'
        }, status: :not_found and return
      end
    else
      @leads = Lead.paginate(page: params[:page], per_page: 20)
    end
    render json: @leads
  end

  # GET /leads/:id
  def show
    begin
      @lead = Lead.find(params[:id])
      render json: @lead, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
