Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry[:dsn]
  config.release = Rails.application.secrets[:release_version]
  config.environment = Rails.application.secrets[:environment_name]
  config.breadcrumbs_logger = %i[sentry_logger active_support_logger http_logger]
  config.traces_sample_rate = 0.5 # might want to lower this once we get things up and running
  config.send_default_pii = true
end
