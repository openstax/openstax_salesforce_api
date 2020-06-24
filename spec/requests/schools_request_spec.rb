require 'rails_helper'

RSpec.describe "Schools", type: :request do

  it "it returns a successful response" do
    get "/api/v1/schools/"
    expect(response).to be_successful
  end

end
