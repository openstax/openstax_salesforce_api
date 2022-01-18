OpenStax::Accounts.configure do |config|
  config.openstax_application_id = Rails.application.secrets.accounts[:openstax_application_id]
  config.openstax_application_secret = Rails.application.secrets.accounts[:openstax_application_secret]
  config.openstax_accounts_url = Rails.application.secrets.accounts[:openstax_accounts_url]
  config.enable_stubbing = ActiveAttr::Typecasting::BooleanTypecaster.new.call(Rails.application.secrets.accounts[:enable_stubbing])
end unless secrets[:openstax_accounts_url].nil?
