redis_secrets = Rails.application.secrets[:redis]

Sidekiq.configure_server do |config|
  config.redis = { url: redis_secrets[:url], network_timeout: 5 }

  config.error_handlers << proc {|ex,ctx_hash| Sentry.capture_exception(ex, ctx_hash) }

  config.death_handlers << ->(job, ex) do
	  Sentry.capture_message "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
  end

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)

  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_secrets[:url], network_timeout: 5 }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end
