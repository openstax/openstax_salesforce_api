require 'rails_helper'
require 'vcr_helper'
require 'spec_helper'

RSpec.describe 'Lists', type: :request, vcr: VCR_OPTS do

  before(:all) do
    @contact = create_contact

    VCR.use_cassette('Pardot/pardot_setup', VCR_OPTS) do
    end
  end

  it 'lists all the users mailing list subscriptions' do
    get '/api/v1/lists/user/0036f00003HhsOlAAJ' # this is a prod test record because we don't have a pardot sandbox
    expect(response).to have_http_status(:success)
  end

  it 'lists all available mailing lists' do
    get '/api/v1/lists'
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body)).to include({ 'description' => 'Monthly updates on OpenStax developments and community perspectives',
                                                   'id' => '246',
                                                   'title' => 'OpenStax Newsletter' },
                                                 { 'description' => 'News about OpenStax Tutor Beta, our adaptive courseware technology',
                                                   'id' => '6223',
                                                   'title' => 'OpenStax Tutor Beta' },
                                                 { 'description' => 'Important information about your OpenStax account',
                                                   'id' => '6225',
                                                   'title' => 'Critical Account Information' },
                                                 { 'description' => 'Learning science research updates and opportunities to be part of a technology pilot',
                                                   'id' => '6227',
                                                   'title' => 'Research Updates' },
                                                 { 'description' => 'Information on how to access additional, book-specific teaching material',
                                                   'id' => '6229',
                                                   'title' => 'OER Commons Hub' },
                                                 { 'description' => 'Information about new or updated textbooks and resources',
                                                   'id' => '6391',
                                                   'title' => 'Textbook news and resource updates' },
                                                 { 'description' => 'OpenStax Tutor Beta adopters ',
                                                   'id' => '12015',
                                                   'title' => 'Tutor Tips' })
  end

  it 'allows user to subscribe to list' do
    get '/api/v1/lists/subscribe/6391/0036f00003HhsOlAAJ'
    expect(response).to have_http_status(302)
    expect(response).to redirect_to('/api/v1/lists/user/0036f00003HhsOlAAJ')
  end

  it 'allows a user to unsubscribe from a list' do
    get '/api/v1/lists/unsubscribe/6391/0036f00003HhsOlAAJ'
    expect(response).to have_http_status(302)
    expect(response).to redirect_to('/api/v1/lists/user/0036f00003HhsOlAAJ')
  end
end
