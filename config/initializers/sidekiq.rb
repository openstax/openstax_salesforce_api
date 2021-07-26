redis_config = Rails.application.secrets.redis

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12" }

  config.death_handlers << ->(job, ex) do
	  Sentry.capture_message "Uh oh, #{job['class']} #{job["jid"]} just died with error #{ex.message}."
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/12" }
end

