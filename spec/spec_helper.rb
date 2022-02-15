RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.default_formatter = 'doc' if config.files_to_run.one?

  # uncomment this to see the 10 slowest tests, useful for debugging tests
  # config.profile_examples = 10

  #config.order = :random

  # clean the database between test runs
  config.prepend_before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # https://github.com/DatabaseCleaner/database_cleaner#rspec-with-capybara-example says:
  #   "It's also recommended to use append_after to ensure DatabaseCleaner.clean
  #    runs after the after-test cleanup capybara/rspec installs."
  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.append_after(:all) do
    DatabaseCleaner.clean
  end
end

"""
SFAPI Helpers
"""
def oxa_cookie
  'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..oJ_QTvZMOu_vpKhn.5y7Ogi3MjK3sfBBAJx2XvWmt_2uInWr0wQpozh2eviaWZNbRNEifsBvcLCrsCfKU2kU4t8jpIH0CinGEVoqe4vt3uTlqz2nQaVkpdR3VrWG4JGmEe1v5gxU6JKcrJdM7sbJFpgFb0g-hKJ_fqVmuTEJSrGsn6UmcLWFtT1rwX2WrIYtjh64bzwoR_z5dtI56E70CAZrnd-L_UV91QpfwDUHhD_lcFD6YiSOMNaz3cJhGfQO5g8g8DYdcU-C5keOKkAmPF0tlltwxWF-CWkzWuo9AIn8fVLkkacL916z5rgszIh7xkEOybqLDT7n0QH-pDmctEWhNd_XiHTeWaO_TOb5RYJvVnlBQXtXbgIVvTRGeT9lwOnWgo0fCILIoewUTeMAd2J8t08mcpUxEb7CiI70vkM0tlsRMWstr--D8tZw4t9G7dzshYpkt3jRcGEGp5NG8dpRQRDkN3_HLrTcR5EuN4ikRBzw-YQKiPtLPnMsuNDkGmarZDyX_apmlHHxGgPH3TcbvFrs06Zaix9vH5JefXvKSpUMo-_8dkShlUSYOSVExd9Kg6K2HXrk2-3jbCFm6HrEjL8DFD5QG1w3UuhuZvlBtkCqsDvxMS8L96CdS4qOGMZxg58wdxTxj9a6b7MCP044G-ZsHfYlbZ00Cnb5Ob2ee1hXgZxuWD73IEKXMkaGe-I8nQ2WT4XLQ-gEeXrcDk77G3XaMtFvqfMSJrAUWdHXGlx1NhnzrUgdQB4aM037KAUpJUi0l12HxD6d29EtzI9Nc0lqHhrlYEia0D8jGHkTdu2BTfBXS-z8BSml06OoXtaNQNDc8ITU3xsevz0-g80ZfJupFlILCkQC4GZx7cN_6lkIbsrESkuP3QRcWdHSsab8D9ANcIT2WYMvubcubgw1vr_SljwMcjjXkHftMEqEC4EQ548BiT4v8mHcZcA6HOCyxkJDD86jn1KZVrucVmsi6nxROR4Jg04jY_vOAPcNkfsdwwETr7sVjXHBmAZsx31HUv4xbCAOUGRP2CiXkDyyx-SRp01mF-vrReijXrUIPdSxBcY1XlMbpAlnlBA48ZLrDL5gkBkYIV48zLvpkYuo3rHKpQhldOeOocbSGxSOw7dmXs2XiGhlS9TgUy3Urizvc_LHymL5r5G525mP-zM_CrnrejZH7aP3fYDXgsB9fZLHcSXbkRZuRsUkJQkmL0-UL35KiBa-IyYhWcRx86OKi9idTW4H02CeY9fuzlf1UCZs0IoSQgQUdwoKggqHooHtle3VlaZ2RB5qE6sOytK_ERlbeImxIzAVeld4_E_KPpvWgZPY-2kN4cr8nUAxb0U8HYdM9-FA2Z_vA0yyhOcbLsYSr0jrtYW3YKAHx-MtEcOGs0RHHljZTgZYxMLLoKRBDbAD73TTkG4wAv0xt0g.b4y4uqYjAGhOpGYQGmaX9g'
end

def set_cookie
  { 'HTTP_COOKIE' => 'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..oJ_QTvZMOu_vpKhn.5y7Ogi3MjK3sfBBAJx2XvWmt_2uInWr0wQpozh2eviaWZNbRNEifsBvcLCrsCfKU2kU4t8jpIH0CinGEVoqe4vt3uTlqz2nQaVkpdR3VrWG4JGmEe1v5gxU6JKcrJdM7sbJFpgFb0g-hKJ_fqVmuTEJSrGsn6UmcLWFtT1rwX2WrIYtjh64bzwoR_z5dtI56E70CAZrnd-L_UV91QpfwDUHhD_lcFD6YiSOMNaz3cJhGfQO5g8g8DYdcU-C5keOKkAmPF0tlltwxWF-CWkzWuo9AIn8fVLkkacL916z5rgszIh7xkEOybqLDT7n0QH-pDmctEWhNd_XiHTeWaO_TOb5RYJvVnlBQXtXbgIVvTRGeT9lwOnWgo0fCILIoewUTeMAd2J8t08mcpUxEb7CiI70vkM0tlsRMWstr--D8tZw4t9G7dzshYpkt3jRcGEGp5NG8dpRQRDkN3_HLrTcR5EuN4ikRBzw-YQKiPtLPnMsuNDkGmarZDyX_apmlHHxGgPH3TcbvFrs06Zaix9vH5JefXvKSpUMo-_8dkShlUSYOSVExd9Kg6K2HXrk2-3jbCFm6HrEjL8DFD5QG1w3UuhuZvlBtkCqsDvxMS8L96CdS4qOGMZxg58wdxTxj9a6b7MCP044G-ZsHfYlbZ00Cnb5Ob2ee1hXgZxuWD73IEKXMkaGe-I8nQ2WT4XLQ-gEeXrcDk77G3XaMtFvqfMSJrAUWdHXGlx1NhnzrUgdQB4aM037KAUpJUi0l12HxD6d29EtzI9Nc0lqHhrlYEia0D8jGHkTdu2BTfBXS-z8BSml06OoXtaNQNDc8ITU3xsevz0-g80ZfJupFlILCkQC4GZx7cN_6lkIbsrESkuP3QRcWdHSsab8D9ANcIT2WYMvubcubgw1vr_SljwMcjjXkHftMEqEC4EQ548BiT4v8mHcZcA6HOCyxkJDD86jn1KZVrucVmsi6nxROR4Jg04jY_vOAPcNkfsdwwETr7sVjXHBmAZsx31HUv4xbCAOUGRP2CiXkDyyx-SRp01mF-vrReijXrUIPdSxBcY1XlMbpAlnlBA48ZLrDL5gkBkYIV48zLvpkYuo3rHKpQhldOeOocbSGxSOw7dmXs2XiGhlS9TgUy3Urizvc_LHymL5r5G525mP-zM_CrnrejZH7aP3fYDXgsB9fZLHcSXbkRZuRsUkJQkmL0-UL35KiBa-IyYhWcRx86OKi9idTW4H02CeY9fuzlf1UCZs0IoSQgQUdwoKggqHooHtle3VlaZ2RB5qE6sOytK_ERlbeImxIzAVeld4_E_KPpvWgZPY-2kN4cr8nUAxb0U8HYdM9-FA2Z_vA0yyhOcbLsYSr0jrtYW3YKAHx-MtEcOGs0RHHljZTgZYxMLLoKRBDbAD73TTkG4wAv0xt0g.b4y4uqYjAGhOpGYQGmaX9g'}
end

def create_contact(salesforce_id: '003U000001i3mWpIAI')
  Contact.where(salesforce_id: salesforce_id).first ||
    FactoryBot.create(:api_contact, salesforce_id: salesforce_id)
end

def search_accounts_result
  {:total_count=>1, :items=>[{:id=>1, :name=>"Ed Woodward", :first_name=>"Ed", :last_name=>"Woodward", :full_name=>"Ed Woodward", :uuid=>"57bbe3d3-d630-4e9c-bc22-f86b701381a0", :support_identifier=>"cs_76415f3f", :is_test=>false, :opt_out_of_cookies=>false, :using_openstax=>false, :salesforce_contact_id=>"0034C00000WsQ06QAF", :faculty_status=>"no_faculty_info", :is_newflow=>true, :is_instructor_verification_stale=>false, :needs_complete_edu_profile=>true, :self_reported_role=>"student", :school_type=>"unknown_school_type", :school_location=>"unknown_school_location", :is_kip=>false, :is_administrator=>true, :grant_tutor_access=>false, :contact_infos=>[{:id=>1, :type=>"EmailAddress", :value=>"ecw1@rice.edu", :is_verified=>true, :is_guessed_preferred=>true}], :applications=>[]}]}.to_json
end

def invalid_search_accounts_result
  {:total_count=>1, :items=>[{:id=>1, :name=>"Ed Woodward", :first_name=>"Ed", :last_name=>"Woodward", :full_name=>"Ed Woodward", :uuid=>"467cea6c-8159-40b1-90f1-e9b0dc26344c", :support_identifier=>"cs_76415f3f", :is_test=>false, :opt_out_of_cookies=>false, :using_openstax=>false, :salesforce_contact_id=>"0030v00000XxX0xXXX", :faculty_status=>"no_faculty_info", :is_newflow=>true, :is_instructor_verification_stale=>false, :needs_complete_edu_profile=>true, :self_reported_role=>"student", :school_type=>"unknown_school_type", :school_location=>"unknown_school_location", :is_kip=>false, :is_administrator=>true, :grant_tutor_access=>false, :contact_infos=>[{:id=>1, :type=>"EmailAddress", :value=>"ecw1@rice.edu", :is_verified=>true, :is_guessed_preferred=>true}], :applications=>[]}]}.to_json
end

"""
  Rspec matcher definitions
"""
RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec::Matchers.define :have_routine_error do |error_code|
  include RSpec::Matchers::Composable

  match do |actual|
    actual.errors.any?{|error| error.code == error_code}
  end

  failure_message do |actual|
    "expected that #{actual} would have error :#{error_code.to_s}"
  end
end

RSpec::Matchers.define :have_api_error_code do |error_code|
  include RSpec::Matchers::Composable

  match do |actual|
    actual.body_as_hash[:errors].any?{|error| error[:code] == error_code}
  end

  failure_message do |actual|
    "expected that response would have error '#{error_code.to_s}' but had #{actual.body_as_hash[:errors].map{|error| error[:code]}}"
  end
end

RSpec::Matchers.define :have_api_error_status do |error_status|
  include RSpec::Matchers::Composable

  match do |actual|
    actual.body_as_hash[:status] == error_status.to_i
  end

  failure_message do |actual|
    "expected that response would have status '#{
      error_status}' but had #{actual.body_as_hash[:status]}"
  end
end

RSpec::Matchers.define :have_error do |field, message|
  # Check a model instance for error presence. For example
  #
  #   model = Model.create(id: already_taken_value, name: 'Name')
  #   expect(model).to have_error(:id, :taken)
  #   expect(model).not_to have_error(:name, :blank)

  include RSpec::Matchers::Composable

  match do |actual|
    actual.errors.types.include? field and actual.errors.types[field].include? message
  end

  failure_message do |actual|
    if actual.errors[field].empty?
      "expected #{actual.model_name} to have errors on #{field}, but it had none"
    else
      msg = error_msg actual.class, field, message
      "expected #{actual.errors[field]} to include #{msg.inspect}"
    end
  end

  failure_message_when_negated do |actual|
    msg = error_msg actual.class, field, message
    "expected #{actual.errors[field]} not to include #{msg.inspect}"
  end
end
