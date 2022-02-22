require 'openstax/auth/strategy_2'

module AuthenticateMethods

  def current_sso_user
    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def current_sso_user_field(field_name)
    current_sso_user&.dig('sub', field_name)
  end

  def current_sso_user_uuid
    @current_sso_user_uuid = OpenStax::Auth::Strategy2.user_uuid(request)
  end

  def current_sso_user_is_admin?
    current_sso_user_field('is_administrator')
  end

  def require_admin
    return head(:forbidden) unless current_sso_user && current_sso_user_is_admin?
  end

  def authorized_for_api?
    return head(:unauthorized) unless current_sso_user_uuid
  end
end
