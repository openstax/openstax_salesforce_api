class Api::V1::OpportunitiesController < ApplicationController

  # GET /opportunities
  def index
    if params['os_accounts_id'].present?
      begin
        @opportunities = Opportunity.where(os_accounts_id: params['os_accounts_id'])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          os_accounts_id: params['os_accounts_id'],
          error: e.to_s,
          status: 'Opportunity not found'
        }
      end
    else
      @opportunities = Opportunity.paginate(page: params[:page], per_page: 20)
    end
    render json: @opportunities
  end

  # GET /opportunities/:id
  def show
    begin
      @opportunity = Opportunity.where(salesforce_id: params[:id])
      render json: @opportunity, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        opportunity_id: params[:id],
        error: e.to_s,
        status: 'Opportunity not found'
      }
    end
  end

  # POST /opportunities(.:format)
  def create
    @opportunity = Opportunity.new(opportunity_params)
    push_opportunity = PushOpportunityToSalesforce.new
    success = push_opportunity.create_new_opportunity(opportunity_params)
    if success
      render json: { opportunity_id: @opportunity.salesforce_id, status: 'Opportunity creation status: Success' }
    else
      @opportunity.salesforce_updated = false
      @opportunity.save
      render json: { opportunity_id: @opportunity.salesforce_id, status: 'Opportunity creation status: Failure' }
    end
  end

  # PATCH/PUT /opportunities/:id(.:format)
  def update
    @opportunity.update(opportunity_params)
    push_opportunity = PushOpportunityToSalesforce.new
    success = push_opportunity.update_opportunity(opportunity_params)
    if success
      render json: { opportunity_id: opportunity_params['salesforce_id'], status: 'Opportunity update status: Success' }
    else
      @opportunity.salesforce_updated = false
      @opportunity.save
      render json: { opportunity_id: opportunity_params['salesforce_id'], status: 'Opportunity update status: Failure' }
    end
  end

  private

  def opportunity_params
    params.require(:opportunity).permit([
      :salesforce_id,
      :term_year,
      :book_name,
      :contact_id,
      :new,
      :close_date,
      :stage_name,
      :type,
      :number_of_students,
      :student_number_status,
      :time_period,
      :class_start_date,
      :school_id,
      :book_id,
      :contact_id,
      :lead_source,
      :os_accounts_id,
      :name
  ])
  end
end
