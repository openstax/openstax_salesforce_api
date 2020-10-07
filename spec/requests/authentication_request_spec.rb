require 'rails_helper'

RSpec.describe "Authentication", type: :request do

  before(:all) do
    @no_access_user = FactoryBot.create(:user, {:username=>'authuser', :password=>'authpassword',:has_access=>false, :is_admin=>false})
    @has_access_user = FactoryBot.create(:user, {:username=>'good_authuser', :password=>'good_authpassword',:has_access=>true, :is_admin=>false})
  end

  it 'fail to get token because user does not exist' do
    #bad user
    headers = { "Authorization" => "testuser:testpassword" }
    post "/auth/authenticate", :headers => headers

    expect(response.body).to include('{"error":"unauthorized"}')
    expect(response).to have_http_status(401)
  end

  it 'successfully get token' do
    headers = { "Authorization" => "good_authuser:good_authpassword" }
    post "/auth/authenticate", :headers => headers

    expect(response.body).to include('{"token":')
    expect(response).to have_http_status(:success)
  end

  it 'fail to get token because user does not have access' do
    headers = { "Authorization" => "authuser:authpassword" }
    post "/auth/authenticate", :headers => headers

    expect(response.body).to include('{"error":"unauthorized"}')
    expect(response).to have_http_status(401)
  end

end
