require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.describe SyncSalesforceBooksJob, type: :job do
  pending "add some examples to (or delete) #{__FILE__}"
end
