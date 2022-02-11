class SyncSalesforceBooksJob < ApplicationJob
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(*args)
    sf_books = OpenStax::Salesforce::Remote::Book.all

    sf_books.each do |sf_book|
      book = Book.find_or_initialize_by(salesforce_id: sf_book.id)
      book.salesforce_id = sf_book.id
      book.name = sf_book.name

      book.save if book.changed?
    end
    JobsHelper.delete_objects_not_in_salesforce('Book', sf_books)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce Book sync - every 1 day', cron: '0 0 * * *', class: 'SyncSalesforceBooksJob')
end
