OpenStax::Accounts.configure do |config|
  secrets = Rails.application.credentials.accounts

  config.openstax_application_id = secrets[:openstax_application_id]
  config.openstax_application_secret = secrets[:openstax_application_secret]
  config.openstax_accounts_url = secrets[:openstax_accounts_url]
  config.enable_stubbing = ActiveAttr::Typecasting::BooleanTypecaster.new.call(secrets[:enable_stubbing])
end unless secrets[:openstax_accounts_url].nil?
