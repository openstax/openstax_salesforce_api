class Api::V1::ContactsController < ApplicationController

  # GET /contacts
  def index
    if params['email'].present?
        @contacts = Contact.where(email: params['email'])
        if @contacts.blank?
          render json: {
              email: params['email'],
              error: 'email not found'
          }, status: :not_found and return
        end
    else
      @contacts = Contact.paginate(page: params[:page], per_page: 20)
    end
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
