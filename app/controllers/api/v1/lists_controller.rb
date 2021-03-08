class Api::V1::ListsController < ApplicationController
  before_action :get_list, only: %i[subscribe unsubscribe]
  before_action :get_contact, only: %i[subscribe unsubscribe]

  # /api/v1/lists/
  # returns all available public lists from Pardot
  def index
    lists = List.all
    render json: lists.to_json
  end

  # /api/v1/lists/<list_id>/subscribe/
  def subscribe
    @subscription = Subscription.where(list: @list, contact: @contact).first_or_initialize

    if @subscription.new_record?
      @subscription.pending!
      SubscribeToListJob.perform_later(@subscription.id)
    end
    head :accepted
  end

  # /api/v1/lists/<list_id>/unsubscribe/
  def unsubscribe
    @subscription = Subscription.find_by!(list: @list, contact: @contact)
    UnsubscribeFromListJob.perform_later(@subscription.id)
    head :accepted
  end

  protected

  def get_list
    @list = List.find_by!(pardot_id: params[:list_id])
  end

  def get_contact
    @contact = Contact.find_by!(salesforce_id: sso_cookie_field('salesforce_contact_id'))
  end
end
