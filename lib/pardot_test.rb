#!/usr/bin/env ruby

require 'ruby-pardot'
require 'pp'
require 'httparty'

@username = ENV['SFDC_USERNAME'] || raise('Environment variable SFDC_USERNAME must be set to the Salesforce username')
@password = ENV['SFDC_PASSWORD'] || raise('Environment variable SFDC_PASSWORD must be set to the Salesforce user\'s password')
@loginUrl = ENV['LOGIN_URL'] || 'https://login.salesforce.com'
pardotUrl = ENV['PARDOT_URL'] || 'https://pi.pardot.com'
@client_id = ENV['CLIENT_ID'] || raise('Environment variable CLIENT_ID must be set to the Connected App\'s Consumer Key')
@client_secret = ENV['CLIENT_SECRET'] || raise('Environment variable CLIENT_SECRET must be set to the Connected App\'s Consumer Secret')
access_token = nil
business_unit_id = nil
version = ENV['API_VERSION'].to_i || 3

TokenResponse = Struct.new(:access_token, :instance_url)

def get_access_token_and_instance_using_username
  parameters = {
    grant_type: 'password',
    client_id: @client_id,
    client_secret: @client_secret,
    username: @username,
    password: @password
  }
  response = HTTParty.post(@loginUrl + '/services/oauth2/token', :query => parameters)
  raise "Failed to contact Salesforce\n#{response.body}" if response.code != 200

  responseJsonObj = JSON.parse response.body, symbolize_names: true

  r = TokenResponse.new
  r.access_token = responseJsonObj[:access_token]
  r.instance_url = responseJsonObj[:instance_url]
  r
end

def get_business_unit_id access_token, instance_url
  raise 'Nil access_token value specified' if access_token.nil?

  parameters = {
    q: 'SELECT Id FROM PardotTenant'
  }
  headers = {
    Authorization: 'Bearer ' + access_token
  }
  response = HTTParty.get(instance_url + '/services/data/v49.0/query/', :query => parameters, :headers => headers)
  raise "Failed to contact Salesforce\n#{response.body}" if response.code != 200

  responseJsonObj = JSON.parse response.body, symbolize_names: true
  totalSize = responseJsonObj[:totalSize]
  raise 'Unable to determine tenants from Salesforce' if totalSize == 0

  warn 'Multiple tenants found for this account. Using the first tenant.' if totalSize > 1
  responseJsonObj[:records][0][:Id]
end

# access Saleforce to get OAuth access_token
# Don't do this in production! Use Web Server flow instead
# See https://help.salesforce.com/articleView?id=sf.remoteaccess_oauth_web_server_flow.htm&type=5
access_token_and_instance = get_access_token_and_instance_using_username

# get the Business-Unit-Id of the first tenant in Salesforce
business_unit_id = get_business_unit_id access_token_and_instance.access_token, access_token_and_instance.instance_url

# Use the Pardot Client to contact pardot
Pardot::Client::base_uri pardotUrl
client = Pardot::Client.new nil, nil, nil, version, access_token_and_instance.access_token, business_unit_id
#prospects = client.prospects.query(:fields => 'id, first_name', :limit => 1)
#pp(prospects)