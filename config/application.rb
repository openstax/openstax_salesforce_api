require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OpenstaxSalesforceApi
  class Application < Rails::Application

    # Because we have a few gems with UIs, we can't active this - but if we setup a separate
    # Blazer instance, we probably can - so keeping this here for ref
    #
    # # API settings
    # config.api_only = true
    #
    # # Remove unneeded middleware
    # config.middleware.delete ::Rack::Sendfile
    #
    # # We are using API only but still need cookie storage for things like Blazer & Sidekiq Web
    # config.session_store :cookie_store, key: "_SFAPI_session_#{Rails.env}"
    # config.middleware.use ActionDispatch::Cookies # Required for all session management
    # config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.active_job.queue_adapter = :sidekiq

    redis_secrets = secrets[:redis]

    # Generate the Redis URL from the its components if unset
    redis_secrets[:url] ||= "redis#{'s' unless redis_secrets[:password].blank?}://#{
      ":#{redis_secrets[:password]}@" unless redis_secrets[:password].blank? }#{
      redis_secrets[:host]}#{":#{redis_secrets[:port]}" unless redis_secrets[:port].blank?}/#{
      "/#{redis_secrets[:db]}" unless redis_secrets[:db].blank?}"

    # config.cache_store = :redis_cache_store, {
    #   url: redis_secrets[:url],
    #   error_handler: -> (exception:) {
    #     # Report errors to Sentry as warnings
    #     Sentry.capture_exception(exception)
    #   }
    # }

    def is_real_production?
      %w[production prod].include? secrets.environment_name
    end

    config.active_record.belongs_to_required_by_default = false
    config.autoload_paths += %W(#{config.root}/lib)

  end
end
