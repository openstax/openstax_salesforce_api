class Book < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(name)
    where(name: name)
  end

  def self.cache_local(sf_book)
    book = Book.find_or_initialize_by(salesforce_id: sf_book.id)
    book.salesforce_id = sf_book.id
    book.name = sf_book.name

    book.save if book.changed?
    book
  end
end
