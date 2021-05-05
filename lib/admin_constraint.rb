require 'openstax_accounts'

class AdminConstraint
  def matches?(request)
    sso_cookie ||= OpenStax::Auth::Strategy2.decrypt(request)
    sso_cookie&.dig('sub', 'is_administrator')
  end
end
