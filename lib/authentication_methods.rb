require 'openstax/auth/strategy_2'

module AuthenticateMethods

  def current_sso_user
    OpenStax::Auth::Strategy2.decrypt(request)
  end

  def current_sso_user_field(field_name)
    current_sso_user&.dig('sub', field_name)
  end

  def current_sso_user_uuid
    current_sso_user_field('uuid')
  end

  def current_sso_user_is_admin?
    current_sso_user_field('is_administrator')
  end

  def require_admin
    return head(:forbidden) unless current_sso_user && current_sso_user_is_admin?
  end

  def authorized_for_api?
    # this bypasses using the sso cookie for local development
    # comment this line out to use production-like auth in development
    # which will require a local accounts install for setting the cookie
    # return if Rails.env.development?
    return head(:unauthorized) unless current_sso_user
  end
end
