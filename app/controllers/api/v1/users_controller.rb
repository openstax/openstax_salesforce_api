class Api::V1::UsersController < Api::V1::BaseController
  def index
    render json: {
      ox_uuid: @uuid,
      opportunities: current_api_user.opportunities,
      contact: current_api_user.contact,
      schools: current_api_user.schools,
      leads: current_api_user.leads,
      subscriptions: current_api_user.subscriptions
    }
  end
end
