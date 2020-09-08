require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = false
  c.ignore_localhost = true
  # To avoid issues with the gem `webdrivers`, we must ignore the driver hosts
  # See https://github.com/titusfortner/webdrivers/wiki/Using-with-VCR-or-WebMock
  #driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
  #c.ignore_hosts(*driver_hosts)

  # %w(
  #   instance_url
  #   username
  #   password
  #   security_token
  #   consumer_key
  #   consumer_secret
  # ).each { |salesforce_secret_name| c.filter_secret(['salesforce', salesforce_secret_name]) }

end

VCR_OPTS = {
    record: ENV.fetch('VCR_OPTS_RECORD', :none).to_sym, # This should default to :none
    allow_unused_http_interactions: false
}
