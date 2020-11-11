require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe "Opportunities", type: :request, vcr: VCR_OPTS do

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
    #adding contact so cookie check works
    contact = FactoryBot.create(:api_contact, salesforce_id: '003U000001i3mWpIAI')
    VCR.use_cassette('OpportunitiesController/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
    end
  end

  it "returns a failure response because of missing cookie" do
    #headers = set_cookie
    get '/api/v1/opportunities/?os_accounts_id=1'
    expect(response).to have_http_status(:bad_request)
  end

  it "returns one opportunity" do
    headers = set_cookie
    get "/api/v1/opportunities/" + @opportunity.salesforce_id + '?os_accounts_id=1', :headers => headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id" do
    headers = set_cookie
    get "/api/v1/opportunities?os_accounts_id=" + @opportunity.os_accounts_id, :headers => headers
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it 'create new opportunity' do
    opportunity_data = create_new_opportunity_data
    headers = set_cookie
    headers["ACCEPT"] = "application/json"
    post "/api/v1/opportunities", :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  it 'update opportunity' do
    @proxy = SalesforceProxy.new
    @proxy.setup_cassette
    opportunity_data = create_update_opportunity_data
    headers = set_cookie
    headers["ACCEPT"] = "application/json"
    put "/api/v1/opportunities/" + @opportunity.id.to_s, :params => opportunity_data, :headers => headers

    expect(response.content_type).to eq("application/json; charset=utf-8")
    expect(response).to have_http_status(:success)
  end

  def create_new_opportunity_data
    opportunity_data = { opportunity: {
      'salesforce_id': '',
      'term_year':'2019 - 20 Spring',
      'book_name':'Behavior',
      'contact_id':'0037X00000cVyfIQAS',
      'new':true,
      'close_date':'2020-09-02',
      'number_of_students': 123,
      'class_start_date':'2020-09-02',
      'school_id':'001U0000007gj6EIAQ',
      'book_id':'zA9gH44q',
      'name': 'OS Salesforce API',
      'stage_name': 'Confirm Adoption Won'
      }
    }
  end

    def create_update_opportunity_data

        opportunity_data = { opportunity: {
          'id':'',
            'salesforce_id':'0067X000007eQMeQAM',
            'term_year':'2019 - 20 Spring',
            'book_name':'Behavior',
            'contact_id':'0037X00000cVyfIQAS',
            'new':true,
            'close_date':'2020-09-02',
            'number_of_students': 123,
            'class_start_date':'2020-09-02',
            'school_id':'001U0000007gj6EIAQ',
            'book_id':'zA9gH44q',
            'name': 'OS Salesforce API',
            'stage_name': 'Confirm Adoption Won'
        }
        }
    end

  def set_cookie
    { 'HTTP_COOKIE' => 'oxa=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..QdX5SwjkpcP0cOaa.SNf1yadprqqloyxKOocEsWaZ3VjWNSUPnHMShKH-ulyr4d5Zj2ReupUBfzRgz-5pwEWZ5iN_LcO-Vc9-NSRBp_QPHpiIMls60nOYTokK5qostdjmUbQGyjV5F3MIfMmZwfbPgY5XJT5T-3MDQ3b4nF8ulBbufsphwsNsl6UFkEp5PjN1FTJ6P9fXkkvQNgmiUuP8QITdbkN6RNvbx3MkNS36Ly44c_HLIEqEZ5QF8M2buovgh_xvNuo56EEywpnKkJfKHQ23eg2ycVtvpeyUhsUpMSyur_L9olcGFyzJIYp6Q_xunXnZDz6hMvt5baOFwaLNyfv20IbqMKeQ-srz9dL9AgY--LwrhW3yvyTZefKApOUigqZ6V4pgicKSqDRpl3LEUYm_yHTSFeUFJoXlXDYa-WbMaK3BvK8qLWQhEo3UtGVlDDtZzva3rCVbSTmc2aav_3c0CsanygiKgctvbC3y3mgUTqQSOj0j06iHsAwi1rQcurqX5uZUN2g-FLHMNU3RQrH7NlxGSX8PrDYhS49q8ER5DvQdoSjIckVSrmaYGLmQxAI4ZRRf0uzULXJLwti4Cz6odbEqKMU5hvg8i8LqoX4reKYHmzNCePQO1W6wltaII7_67kARnS_OQ8_dQQeTkSQiqRxbKyic4M33XMmpkSRdyPQLPlffwtDl4qus5RSgc1RpJHRAJF81GB5nGgP98zr9j8gUIkAPpLoxLR85RLehDUxByVJAmF35p4r6CZ1ABRH3vXH0UBrpLL0OltNJc66E7amzHLhj3JvebF4yIjCVdF4P8qe5f8wopVONjnCmHwRboqs2AknBYpdVGMb0SbyYugthx3NgfCblrjMGtLN00z_N4UUP_ktW16dzrV_PMxrsBpeI1J2PwLG_HxxmT8J8fZocwmS0PQShxqcwjmMwHAyq60VBkbXdBSvTMkTnrv1MiFIb2ad-ASKtURL5ZwxeGl06u8sUW3QowEkLYJdMnggoc4dWi9ak36TOpDsSL34nLErCTFk96xStUNDxmRUWHQ14VNDdhvMcc3ryVYoV5wpiK3Xpwu6-5-H_4AhuWmOiHDTW6e5I7iohdA5TvRZ5VZPSiqSH30AHIXLfk3VPU7wG30MiVW-eYaQFH9wYGT3hJLpBUwoOAkj_ZRrxSTLQsE8b09SZAwkuArPj4XcWHtEDOekhqzy1z9v8aIN5ysrIHJvQubKjguKYi_rky4OrL-vEkiF6K4ayaCcQQaD0B09ajinUbFZDiIbqc8kM0FAVs98_Okb8xcgA_IGaibM02dxgy-sMoQ.QtbCTF_nrjVm_SQpHsB02w'}
  end

end
