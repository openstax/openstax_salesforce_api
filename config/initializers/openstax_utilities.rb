OpenStax::Utilities.configure do |config|
  config.status_authenticate = -> do
    #TODO: add a check to /api/user to check if is_administrator before allowing access on prod
    next if !Rails.application.is_real_production?

    raise SecurityTransgression
  end
  secrets = Rails.application.secrets
  config.environment_name = secrets.environment_name
  config.backend = 'sfapi'
  config.release_version = secrets.release_version
  config.deployment = 'bit-deployment'
  config.deployment_version = secrets.deployment_version
end
