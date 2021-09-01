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

  # POST /opportunities(.:format)
  def create
    @lead = Lead.new(lead_params)
    @lead.save!

    PushLeadToSalesforceJob.perform_later(@lead)
    render json: @lead, status: :accepted
  end

  private

  def lead_params
    params.require(:lead).permit(%i[
                                          salesforce_id
                                          first_name
                                          last_name
                                          salutation
                                          subject
                                          school
                                          phone
                                          website
                                          status
                                          email
                                          source
                                          newsletter
                                          newsletter_opt_in
                                          adoption_status
                                          num_students
                                          os_accounts_id
                                          accounts_uuid
                                          application_source
                                          role
                                          who_chooses_books
                                          verification_status
                                          finalize_educator_signup
                                        ])
  end
end
