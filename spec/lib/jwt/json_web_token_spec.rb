require 'rails_helper'
#require 'jwt/json_web_token'

describe JsonWebToken do

  it 'encode token' do
    token = JsonWebToken.encode(username: 'testusername')

    expect(token).not_to be_empty
  end

  it 'decode token' do
    token = JsonWebToken.encode(username: 'testusername')
    decoded_token = JsonWebToken.decode(token)

    expect(decoded_token['username']).to eq('testusername')
  end




end
