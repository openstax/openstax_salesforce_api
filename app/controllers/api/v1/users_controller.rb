class Api::V1::UsersController < Api::V1::BaseController
  before_action :current_api_user

  def index
    render json: {
      ox_uuid: current_sso_user_uuid,
      opportunities: @user&.opportunities,
      contact: @user&.contact,
      schools: @user&.schools,
      leads: @user&.leads,
      subscriptions: @user&.subscriptions
    }
  end
end
