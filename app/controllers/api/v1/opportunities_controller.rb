class Api::V1::OpportunitiesController < Api::V1::BaseController
  # GET /opportunities/:id
  def show
    @opportunity = Opportunity.find_by!(salesforce_id: params[:id])
    render json: @opportunity, status: :ok
  end

  # POST /opportunities(.:format)
  def create
    @opportunity = Opportunity.new(opportunity_params)
    book = Book.find_by!(name: @opportunity.book_name)
    @opportunity.book_id = book.salesforce_id
    @opportunity.record_type_id = Opportunity.first.record_type_id
    @opportunity.save!

    PushOpportunityToSalesforceJob.perform_later(@opportunity)
    render json: @opportunity, status: :accepted
  end

  # PATCH/PUT /opportunities/:id(.:format)
  def update
    @opportunity = Opportunity.find_by!(salesforce_id: params[:id])
    @opportunity.attributes = opportunity_params
    @opportunity.save!

    PushOpportunityToSalesforceJob.perform_later(@opportunity)
    render json: @opportunity, status: :accepted
  end

  # GET /opportunities/search?accounts_uuid=
  def search
    @opportunity = Opportunity.find_by!(accounts_uuid: params[:accounts_uuid])
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
                                          accounts_uuid
                                          name
                                        ])
  end
end
