class UpdateBooksFromSalesforce
  def start_update
    sf_books = retrieve_salesforce_data
    update_books(sf_books)
  end

  def retrieve_salesforce_data
    OpenStax::Salesforce::Remote::Book
        .select(:id, :name)
        .to_a
  end

  def update_books(sf_books)
    sf_books.each do |sf_book|
      book_to_update = Book.find_or_initialize_by(salesforce_id: sf_book.id)
      book_to_update.salesforce_id = sf_book.id
      book_to_update.name = sf_book.name

      book_to_update.save if book_to_update.changed?
    end
  end
end
