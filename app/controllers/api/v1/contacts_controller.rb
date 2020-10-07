class Api::V1::ContactsController < ApplicationController
  before_action :authorize_request

  # GET /contacts
  def index
    @contacts = Contact.paginate(page: params[:page], per_page: 20)
    render json: @contacts
  end

  # GET /contacts/:id
  def show
    begin
      @contact = Contact.find(params[:id])
      render json: @contact, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
