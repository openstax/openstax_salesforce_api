class Book < ApplicationRecord
  validates :salesforce_id, presence: true, uniqueness: true

  def self.search(name)
    where(name: name)
  end

  # expects an object of type
  # OpenStax::Salesforce::Remote::Book
  def self.cache_local(sf_book)
    self.find_or_initialize_by(salesforce_id: sf_book.id)
    self.name = sf_book.name

    self.save if self.changed?
    self
  end
end
