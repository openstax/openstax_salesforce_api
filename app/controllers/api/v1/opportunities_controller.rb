require 'push_opportunity_to_salesforce'

class Api::V1::OpportunitiesController < Api::V1::BaseController
  # GET /opportunities
  def index
    if params['os_accounts_id'].present?
      begin
        @opportunities = Opportunity.where(os_accounts_id: params['os_accounts_id'])
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          os_accounts_id: params['os_accounts_id'],
          error: e.to_s
        }, status: :not_found
      end
    else
      @opportunities = Opportunity.paginate(page: params[:page], per_page: 20)
    end
    render json: @opportunities
  end

  # GET /opportunities/:id
  def show
    @opportunity = Opportunity.where(salesforce_id: params[:id])
    render json: @opportunity, status: :ok
  end

  # POST /opportunities(.:format)
  def create
    push_opportunity = PushOpportunityToSalesforce.new
    sf_opportunity = push_opportunity.create_new_opportunity(opportunity_params)
    if !sf_opportunity.blank? && !sf_opportunity.id.blank?
      @opportunity = Opportunity.new(opportunity_params)
      # setting the value this way because of issue with the Salesforce field named 'type'
      @opportunity.update_type = 'New Business'
      @opportunity.salesforce_id = sf_opportunity.id
      if @opportunity.save
        render json: { opportunity_id: @opportunity.salesforce_id, status: 'SFAPI and SF Opportunity creation status: Success' }
      else
        render json: { opportunity_id: sf_opportunity.id, status: 'SFAPI Opportunity creation status: Failure. SF Opportunity creation status: Success' }
      end
    end
  end

  # PATCH/PUT /opportunities/:id(.:format)
  def update
    @opportunity = Opportunity.where(salesforce_id: opportunity_params[:salesforce_id])
    if !@opportunity.blank?
      @opportunity.update(opportunity_params)
      # setting the value this way because of issue with the Salesforce field named 'type'
      @opportunity[0].update_type = 'Renewal - Verified'
      if @opportunity[0].save
        push_opportunity = PushOpportunityToSalesforce.new
        sf_opportunity = push_opportunity.update_opportunity(opportunity_params)
        if sf_opportunity.errors.none?
          render json: { opportunity_id: @opportunity[0].salesforce_id, status: 'SFAPI and SF Opportunity update status: Success' }
        else
          @opportunity[0].salesforce_updated = false
          if @opportunity[0].save
            render json: { opportunity_id: @opportunity[0].salesforce_id, status: 'SFAPI Opportunity update status: Success. SF Opportunity update status: Failure. Will retry.' }
          end
        end
      else
        render json: { opportunity_id: @opportunity[0].salesforce_id, status: 'SFAPI Opportunity update status: Failure. Did not attempt SF Update.' }
      end
    else
      render json: { opportunity_id: opportunity_params[:salesforce_id], status: 'Opportunity update status: Failure. Opportunity not found in SFAPI.' }
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
