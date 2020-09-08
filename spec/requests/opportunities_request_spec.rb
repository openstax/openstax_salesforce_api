require 'rails_helper'

RSpec.describe "Opportunities", type: :request do

  before(:all) do
    @opportunity = FactoryBot.create :api_opportunity
  end

  it "returns a successful response for all opportunities" do
    get "/api/v1/opportunities/"
    expect(response).to be_successful
  end

  it "returns one opportunity" do
    get "/api/v1/opportunities/" + @opportunity.salesforce_id
    expect(JSON.parse(response.body).size).to be >= 1
    expect(response).to have_http_status(:success)
  end

  it "returns opportunity using os_accounts_id" do
    opportunity = Opportunity.first
    get "/api/v1/opportunities?os_accounts_id=" + opportunity.os_accounts_id
    expect(JSON.parse(response.body).size).to eq(1)
    expect(response).to have_http_status(:success)
  end

end
