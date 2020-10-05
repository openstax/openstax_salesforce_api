require 'rails_helper'
require 'jwt/json_web_token'

describe JsonWebToken do

  it 'encode token' do
    token = JsonWebToken.encode(user_id: 'testusername')

    expect(token).not_to be_empty
  end

  it 'decode token' do
    decoded_token = JsonWebToken.decode('eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoidGVzdHVzZXJuYW1lIiwiZXhwIjoxNjAyMDA4NTM0fQ.sE4sXAfU2tWgtUh5jqmpVbzL5SORy7OG3iprMbCe-QM')

    expect(decoded_token['user_id']).to eq('testusername')
  end




end
