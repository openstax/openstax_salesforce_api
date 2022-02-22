require 'factory_bot'
require_relative 'sfapi_helpers'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot::SyntaxRunner.send(:include, SFAPISupport)
