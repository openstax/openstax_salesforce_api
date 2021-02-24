class Api::V1::ListsController < ApplicationController
  # /api/v1/lists/
  # returns all available public lists from Pardot
  def available_lists
    lists = List.all
    render json: lists.to_json
  end

  # /api/v1/lists/subscribe/<list_id>/<salesforce_id>
  def subscribe
    list = List.find_by(pardot_id: params[:list_id])
    contact = Contact.find_by(salesforce_id: params[:salesforce_id])

    Subscription.create(list: list, contact: contact)
    SubscribeToListJob.perform_later(list.pardot_id, contact.salesforce_id)
    head :accepted
  end

  # /api/v1/lists/unsubscribe/<list_id>/<salesforce_id>
  def unsubscribe
    list = List.find_by(pardot_id: params[:list_id])
    contact = Contact.find_by(salesforce_id: params[:salesforce_id])

    Subscription.delete_by(list: list, contact: contact)
    UnsubscribeToListJob.perform_later(list.pardot_id, contact.salesforce_id)
    head :accepted
  end
end
