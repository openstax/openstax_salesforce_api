require_relative '../lib/authentication_methods'

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
  @oxa_cookie = 'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..zdpEdwgWJFxMhsSj.TlQEGSWHdrH6KHhYSR9zQvVhjFGNOuXjWWmuRbK5UUVHePTfI-W_dR-x2ObCoqVarew7FR6h1p_E4Ddk5bA9vH5-v6PNqTOlGuDwqs1x6GjA9yzYMsALGryXlXwE1kaMDSbt9XDUD5Sv2yfYcL_5g3Dan_H5WH8wad9Zqm8ziNDfwEvSTzRXe9W_Wgr7Nto9HWtzko8VE7pm0_mgYoUjtQxN_kDDca-6NSKEeldGQK-IpQY6OMjinVwPbea6iA23ZOM3U1TJmKirWtYt7mnpfn9X8LYQp9OVniWFJGLiy1x7lUdBspPSePJgWGihQM7GfG8HHRGJPhlbSFzYu3FbEi2BH2OmQ3UXEN6J1IGBPKwQe2xaZxRDKGGV9t9CUDfaSvP6SXU8qRFwB4TM1EtyaKOgjwunq2tUk_h7UDF2gfyKFByT5__fCghWk-Ex1vjpymCKTRLZXD9pSpmZXxRbxD-g9u32BFcefcMN2xzFhV19_VX6nha2MYsnpM2gTR6wuwhtz-LCNsVHeoVyW4rDhxQDsquVXYBszNckr8f_ENkLf8BfF9dCh75WicNt8SzZkoK8_NO3IRJkbjSePE1rjptIxSGxdG8PYWqyoNGdKGEXKGSRzSBY-Qha84MXWrpx7kuejVVwl6Sw0pGNLJIX9bM6JAxWKa9xdTWe09mQ0fdJHjT6NyoSxe4JxqFm8CL4uv-JrwwS9TXVtDxi0iUe7E3bTRprwsugTb2K-WfLNJBz0IxNt3YGaLeXdhmEcTHpkoiaMqYQfhTZmD5vKSCX925Ky-eAnn4TGQgJYbppvpX6hveeEpzaifgD-69HETri-ie6zgpiXlBsXlKbmhdSs8QDWYF-3E5YAZyHFEY7Cr6_Tmby6ibjZUbdjfWJkii52UaE2sQWCUQt9S2Kl4wtd7FAyUD9e2ATEETPBqTXkZ8L0gJ7wOksah5_96uARpnIibHiYJ_IbYQZazssgmPLb5XXRuBroq1HFSA6HkaK3YJEYBXrPMNMMHPQk37qrdXUxdnDQBLoKCFqBkSTc9e6_9EXseOjpx3mfIPSehXJmnMtCPxUFJO_8QaPKyGXpxA3vYyYMUY7Q_Ai19AEG3YqzHQOdk2nQTQvA_jvBQCXWXAEh_rNgMM0IdhWO_Awxqa2zOnIoJuFGorbgPYS8ZZbo1RVtqY_AAzojReDopJz60NH9T5ltD4u2TgfRRSBRem9_g1gQLun5SiHr99-RvrqiA6iTzZyGKeOanf1HL8CdSUtBNVWkmn1SqRXZcWTk6pFACJM67YPeCvuJn5zjjCG815axqdbdDqNEAtQRKKsHnmeIDJEgPUfiAYG9lN5DrGngqr33GN5HL47xs3JXXX6LK8_WKueHoeEdW_-KFCzr02gvZPAgIJR0LwKI2XYGajtVitaP-VKyW2sbH_vkaTlu6bKtwtQon1191etd7Q78AnW6Rm7h6ZJwAS9AbR8CUEqK70O5nHYBYRJw-vcQzZKpiTvTSw75rbM-sF_rdYR8mUOyXBlsJbCB_R6hkAXdoD16ZC4BA1ZvLB2jJm7lS4AhVd_7iR8a1kBHVZnI28B_ruZE3jqFFa7FurjgDnnnyfdU6W0-uQ2DHC5fk4DjSU18Y_7eRFfWIu85PmknW5ma4KYoQO7-o714njGRPsB0mFja_UFBsp1_trNkwUjEJ9mvJQMM4ZW9aD_097SF71IaANCh0xI1c5N7zBip9cUOe8lFttQIdI9ns9DUgeE1WDMWvBPUKDO6dnYhjIMZje2sAx6DtPA5ldiIuVYN5S7D3eVgxubQn43HXJJuomhVVlOHOwbyHLjBMuUT7f3dLzXGHbLIQtnW9-sHl1xnU_R7McslkghQMmk79YPo2J6iypnVpppZba-YqvcWqxh5YLYC9JAC-_-WaRyEQ18t3JOBcBma8B0a85zICyO187-cSbFObL3ZIt02ZP7624CpFce31NMa9-Sk09ulssD31S-l0YBz148uWAtGWbbbzJhEQdVyRtL6sSxfQQKPylE5xyjQC8BqOwZ1iMt62BTH8CQuFQgnzeJ2kC9fZMMbNs.LaO7JKdkUrINwub8EM0sTA'
end

def set_cookie
  { 'HTTP_COOKIE' => @oxa_cookie }
end

def create_contact
  @sf_contact = OpenStax::Salesforce::Contact.any?
  @contact = Contact.cache_local(@sf_contact)
end

def search_accounts_result
  @account_result = OpenStax::Auth::Strategy2.decrypt(@oxa_cookie)
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
