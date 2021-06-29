class Api::V1::OpportunitiesController < Api::V1::BaseController
  # GET /opportunities
  def index
    @opportunities = Opportunity.paginate(page: params[:page], per_page: 20)
    render json: @opportunities
  end

  # GET /opportunities/:id
  def show
    @opportunity = Opportunity.where(salesforce_id: params[:id])
    render json: @opportunity, status: :ok
  end

  # POST /opportunities(.:format)
  def create
    PushOpportunityToSalesforceJob.perform_now(opportunity_params)
    head :accepted
  end

  # PATCH/PUT /opportunities/:id(.:format)
  def update
    PushOpportunityToSalesforceJob.perform_now(opportunity_params)
    head :accepted
  end

  # GET /opportunities/search?os_accounts_id
  def search
    @opportunity = Opportunity.search(params[:os_accounts_id])
    render json: @opportunity, status: :ok
  end

  private

  def opportunity_params
    params.require(:opportunity).permit(%i[
                                          salesforce_id
                                          term_year
                                          book_name
                                          contact_id
                                          new
                                          close_date
                                          stage_name
                                          number_of_students
                                          student_number_status
                                          time_period
                                          class_start_date
                                          school_id
                                          book_id
                                          contact_id
                                          lead_source
                                          os_accounts_id
                                          name
                                        ])
  end
end
