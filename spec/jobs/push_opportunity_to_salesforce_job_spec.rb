require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe PushOpportunityToSalesforceJob, type: :job, vcr: VCR_OPTS do
  before(:all) do
    VCR.use_cassette('PushOpportunityToSalesforceJob/sf_setup', VCR_OPTS) do
      @proxy = SalesforceProxy.new
      @proxy.setup_cassette
      # @school = @proxy.schools[0]
      # @contact = @proxy.new_contact(first_name: Faker::Name.first_name,
      #                               last_name: Faker::Name.last_name,
      #                               school_name: @school.name,
      #                               email: Faker::Internet.safe_email,
      #                               faculty_verified: 'confirmed_faculty'
      #                               )
      # @book = @proxy.books[0]
    end
  end

  before(:each) do
    Sidekiq::Worker.clear_all
  end

  it { is_expected.to be_processed_in :opportunities }
  it { is_expected.to be_retryable true }

  it 'pushes a new opportunity' do
    #fake_opp = FactoryBot.build :opportunity, contact_id: @contact.id, book_id = @book.id, book_name = @book.name
    pending("Need to implement")
    raise "Not Implemented"
  end

  it 'renews an existing opportunity' do
    # fake_opp = FactoryBot.create :opportunity
    # fake_opp.contact_id = @contact.id
    # fake_opp.book_id = @book.id
    # fake_opp.book_name = @book.name

    # PushOpportunityToSalesforceJob.new.perform(fake_opp.accounts_uuid)
    # expect(fake_opp.salesforce_id).to_not be_nil
    #
    # # should now have a SF id, so be processed as a renewal
    # PushOpportunityToSalesforceJob.new.perform(fake_opp.accounts_uuid)
    # expect(fake_opp.update_type).to eq(Opportunity.update_types[:renewal])
    pending("Need to implement")
    raise "Not Implemented"
  end
end
