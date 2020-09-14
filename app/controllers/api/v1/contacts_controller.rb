class Api::V1::ContactsController < ApplicationController

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
