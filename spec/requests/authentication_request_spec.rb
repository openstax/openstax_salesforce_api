require 'rails_helper'

RSpec.describe "Authentication", type: :request do

  before(:all) do
    @user = FactoryBot.create(:user, {:username=>'authuser', :password=>'authpassword',:has_access=>false, :is_admin=>false})
  end

  it 'fail to get token' do
    headers = { "Authorization" => "testuser:testpassword" }
    post "/auth/authenticate", :headers => headers

    expect(response.body).to include('{"error":"unauthorized"}')
    expect(response).to have_http_status(401)
  end

  it 'successfully get token' do
    headers = { "Authorization" => "authuser:authpassword" }
    post "/auth/authenticate", :headers => headers

    expect(response.body).to include('{"token":')
    expect(response).to have_http_status(:success)
  end

end
