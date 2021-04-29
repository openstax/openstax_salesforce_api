require 'openstax_accounts'

class AdminConstraint
  def matches?(request)
    sso_cookie ||= OpenStax::Auth::Strategy2.decrypt(request)
    #return false unless request.cookie_jar[Rails.application.secrets.accounts[:sso][:cookie_name]].present?
    #sso_cookie ||= OpenStax::Auth::Strategy2.decrypt(request)
    puts sso_cookie.inspect
    sso_cookie&.dig('sub', 'is_administrator')
    #true


  end
end
