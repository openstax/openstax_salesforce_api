require 'rails_helper'

RSpec.describe "Logins", type: :request do
  before(:all) do
    @no_app_access_user = FactoryBot.create(:user, {:username=>'authuser_app', :password=>'authpassword',:has_access=>false, :is_admin=>false})
    @has_app_access_user = FactoryBot.create(:user, {:username=>'good_authuser_app', :password=>'good_authpassword',:has_access=>true, :is_admin=>true})
  end

  it 'successfully login' do

    post "/login", params: {
      id: @has_app_access_user.id,
      login: {
        username: 'good_authuser_app',
        password: 'good_authpassword'
      }
    }

    expect(response).to have_http_status(302)
  end

  it 'unsuccessfully login' do

    post "/login", params: {
        id: @no_app_access_user.id,
        login: {
            username: 'authuser_app',
            password: 'authpassword'
        }
    }
    expect(response.body).to include('You must be an admin to log in')
    expect(response).to have_http_status(:success)
  end

end
