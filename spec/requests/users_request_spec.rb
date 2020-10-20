require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:all) do
    @no_access_user = FactoryBot.create(:user, {:username=>'authuser', :password=>'authpassword',:has_access=>false, :is_admin=>false})
    @has_access_user = FactoryBot.create(:user, {:username=>'good_authuser', :password=>'good_authpassword',:has_access=>true, :is_admin=>true})
    @delete_user = FactoryBot.create(:user, {:username=>'deleteuser', :password=>'deletepassword',:has_access=>true, :is_admin=>true})
  end

  it 'add user' do
    login
    post '/users', params: {
      user: {
          username: 'test-new-user',
          password: 'authpassword',
          is_admin: false,
          has_access: true
      }
    }
    new_user = User.find_by_username('test-new-user')
    expect(new_user.username).to eq 'test-new-user'
    expect(new_user.is_admin).to eq false
    expect(new_user.has_access).to eq true
    expect(response).to have_http_status(302)
  end

  it 'edit user' do
    login
    patch '/users/' + @no_access_user.id.to_s, params: {
      user: {
        username: 'authuser-edited',
        #password: 'authpassword',
        is_admin: false,
        has_access: false
      }
    }
    new_user = User.find_by_username('authuser-edited')
    expect(new_user.username).to eq 'authuser-edited'
    expect(new_user.is_admin).to eq false
    expect(new_user.has_access).to eq false
    expect(response).to have_http_status(302)
  end

  it 'delete user' do
    login
    delete '/users/' + @delete_user.id.to_s, params: {
      user: {
        username: 'deleteuser',
        password: 'deletepassword',
        is_admin: true,
        has_access: true
      }
    }
    deleted_user = User.find_by_username('deleteuser')
    expect(deleted_user).to eq nil
    expect(response).to have_http_status(302)
  end

  def login
    post "/login", params: {
      id: @has_access_user.id,
      login: {
        username: 'good_authuser',
        password: 'good_authpassword'
      }
    }
  end

end
