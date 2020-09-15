require 'rails_helper'
require 'update_books_from_salesforce'

describe UpdateBooksFromSalesforce do
  let(:ubfs) { UpdateBooksFromSalesforce.new }

  it 'update books' do
    stub_books
    ubfs.update_books(@sf_books)

    expect Book.count == @sf_books.count
  end

  def stub_books
    @sf_books = FactoryBot.create_list('salesforce_book', 12)
  end
end
