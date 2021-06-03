class Api::V1::ContactsController < Api::V1::BaseController
  # GET /contacts
  def index
    @contacts = Contact.paginate(page: params[:page], per_page: 20)
    render json: @contacts
  end

  # GET /contacts/:id
  def show
    @contact = Contact.find_by!(salesforce_id: params[:id])
    render json: @contact, status: :ok
  end

  # GET /contacts/search?email
  def search
    @contact = Contact.search(params[:email])
    render json: @contact, status: :ok
  end

  # PATCH/PUT /contacts/:contact_id/:school_id
  def add_school
    @contact = Contact.find_by!(salesforce_id: params[:contact_id])
    @school = School.find_by!(salesforce_id: params[:school_id])
    relation = OpenStax::Salesforce::Remote::AccountContactRelation.new(
      contact_id: @contact.salesforce_id,
      school_id: @school.salesforce_id
    )
    relation.save

    if relation.errors.any?
      Rails.logger.warn('Error creating school/contact relation in salesforce:' + relation.errors.inspect)
    end

  end

  # DELETE /contacts/:relation_id
  def remove_school
    OpenStax::Salesforce::Remote::AccountContactRelation.destory(
      id: params[:relation_id]
    )
  end
end
