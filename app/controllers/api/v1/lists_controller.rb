class Api::V1::ListsController < Api::V1::BaseController
  before_action :get_list, only: %i[subscribe unsubscribe]

  # /api/v1/lists/
  # returns all available public lists from Pardot
  def index
    lists = List.all
    render json: lists
  end

  # /api/v1/lists/<list_id>/subscribe/
  def subscribe
    @subscription = Subscription.where(list: @list, contact: current_contact!).first_or_initialize

    if @subscription.new_record? || @subscription.pending_destroy?
      @subscription.pending_create!
      SubscribeToListJob.perform_later(@subscription)
    end
    head :accepted
  end

  # /api/v1/lists/<list_id>/unsubscribe/
  def unsubscribe
    @subscription = Subscription.find_by!(list: @list, contact: current_contact!)
    @subscription.pending_destroy!
    UnsubscribeFromListJob.perform_later(@subscription)
    head :accepted
  end

  protected

  def get_list
    @list = List.find_by!(pardot_id: params[:list_id])
  end
end
