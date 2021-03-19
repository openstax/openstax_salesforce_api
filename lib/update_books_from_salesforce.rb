class UpdateBooksFromSalesforce
  def self.call
    new.start_update
  end

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
    delete_books_removed_from_salesforce(sf_books)
  end

  def delete_books_removed_from_salesforce(sf_books)
    sfapi_books = Book.all

    sfapi_books.each do |sfapi_book|
      found = false
      sf_books.each do |sf_book|
        found = true if sf_book.id == sfapi_book.salesforce_id
        break if found
      end
      Book.destroy(sfapi_book.id) unless found
    end
  end
end
