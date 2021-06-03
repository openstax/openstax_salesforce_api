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
    AccountContactRelation.new(
      contact_id: params[:contact_id],
      school_id: params[:school_id]
    ).save

    OpenStax::Salesforce::Remote::AccountContactRelation.new(
      contact_id: params[:contact_id],
      school_id: params[:school_id]
    ).save
  end

  # DELETE /contacts/:relation_id
  def remove_school
    OpenStax::Salesforce::Remote::AccountContactRelation.destory(
      id: params[:relation_id]
    )
  end
end
