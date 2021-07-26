Sentry.init do |config|
  config.dsn = Rails.application.secrets.sentry[:dsn]
  config.breadcrumbs_logger = %i[sentry_logger active_support_logger http_logger]
  config.traces_sample_rate = 0.5 # might want to lower this once we get things up and running
  config.send_default_pii = true
end
