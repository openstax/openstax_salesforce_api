class Api::V1::ContactsController < Api::V1::BaseController
  # index and show routes are excluded for this controller and the tests have been removed until the API is needed
  # The search route has been commented out and the tests removed until the API is needed

  # GET /contacts/:id
  def show
    @contact = Contact.find_by!(salesforce_id: params[:id])
    render json: @contact
  end

  # GET /contacts/search?email
  def search
    @contact = Contact.search(params[:email])
    render json: @contact
  end

  # POST /contacts/add_school/:contact_id/:school_id
  def add_school
    relation = AccountContactRelation.new(
      contact_id: params[:contact_id],
      school_id: params[:school_id]
    )
    relation.save!

    SyncContactSchoolsToSalesforceJob.perform_later(relation, 'add')
    head :processing

  rescue ActiveRecord::RecordInvalid
    head(:method_not_allowed)

  end

  # DELETE /contacts/remove_school/:contact_id/:school_id
  def remove_school
    relation = AccountContactRelation.find_by!(
      contact_id: params[:contact_id],
      school_id: params[:school_id]
    )

    if relation.primary? # cannot delete primary school
      head(:method_not_allowed)
    end

    SyncContactSchoolsToSalesforceJob.perform_later(relation, 'remove')
    head :processing
  end
end
