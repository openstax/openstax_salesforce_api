require 'simplecov'
SimpleCov.start
require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.default_formatter = 'doc' if config.files_to_run.one?

  # uncomment this to see the 10 slowest tests, useful for debugging tests
  # config.profile_examples = 10

  config.order = :random
end

def set_cookie
  { 'HTTP_COOKIE' => 'oxa=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..QdX5SwjkpcP0cOaa.SNf1yadprqqloyxKOocEsWaZ3VjWNSUPnHMShKH-ulyr4d5Zj2ReupUBfzRgz-5pwEWZ5iN_LcO-Vc9-NSRBp_QPHpiIMls60nOYTokK5qostdjmUbQGyjV5F3MIfMmZwfbPgY5XJT5T-3MDQ3b4nF8ulBbufsphwsNsl6UFkEp5PjN1FTJ6P9fXkkvQNgmiUuP8QITdbkN6RNvbx3MkNS36Ly44c_HLIEqEZ5QF8M2buovgh_xvNuo56EEywpnKkJfKHQ23eg2ycVtvpeyUhsUpMSyur_L9olcGFyzJIYp6Q_xunXnZDz6hMvt5baOFwaLNyfv20IbqMKeQ-srz9dL9AgY--LwrhW3yvyTZefKApOUigqZ6V4pgicKSqDRpl3LEUYm_yHTSFeUFJoXlXDYa-WbMaK3BvK8qLWQhEo3UtGVlDDtZzva3rCVbSTmc2aav_3c0CsanygiKgctvbC3y3mgUTqQSOj0j06iHsAwi1rQcurqX5uZUN2g-FLHMNU3RQrH7NlxGSX8PrDYhS49q8ER5DvQdoSjIckVSrmaYGLmQxAI4ZRRf0uzULXJLwti4Cz6odbEqKMU5hvg8i8LqoX4reKYHmzNCePQO1W6wltaII7_67kARnS_OQ8_dQQeTkSQiqRxbKyic4M33XMmpkSRdyPQLPlffwtDl4qus5RSgc1RpJHRAJF81GB5nGgP98zr9j8gUIkAPpLoxLR85RLehDUxByVJAmF35p4r6CZ1ABRH3vXH0UBrpLL0OltNJc66E7amzHLhj3JvebF4yIjCVdF4P8qe5f8wopVONjnCmHwRboqs2AknBYpdVGMb0SbyYugthx3NgfCblrjMGtLN00z_N4UUP_ktW16dzrV_PMxrsBpeI1J2PwLG_HxxmT8J8fZocwmS0PQShxqcwjmMwHAyq60VBkbXdBSvTMkTnrv1MiFIb2ad-ASKtURL5ZwxeGl06u8sUW3QowEkLYJdMnggoc4dWi9ak36TOpDsSL34nLErCTFk96xStUNDxmRUWHQ14VNDdhvMcc3ryVYoV5wpiK3Xpwu6-5-H_4AhuWmOiHDTW6e5I7iohdA5TvRZ5VZPSiqSH30AHIXLfk3VPU7wG30MiVW-eYaQFH9wYGT3hJLpBUwoOAkj_ZRrxSTLQsE8b09SZAwkuArPj4XcWHtEDOekhqzy1z9v8aIN5ysrIHJvQubKjguKYi_rky4OrL-vEkiF6K4ayaCcQQaD0B09ajinUbFZDiIbqc8kM0FAVs98_Okb8xcgA_IGaibM02dxgy-sMoQ.QtbCTF_nrjVm_SQpHsB02w'}
end

def create_contact(salesforce_id: '003U000001i3mWpIAI')
  contact = Contact.where(salesforce_id: salesforce_id).first
  contact = FactoryBot.create(:api_contact, salesforce_id: salesforce_id) if contact.blank?
  contact
end

def create_token_header
  application =  FactoryBot.create(:application)
  token = FactoryBot.create(:doorkeeper_access_token, application: application)
  { 'Authorization': 'Bearer ' + token.token }
end
