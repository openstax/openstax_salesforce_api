class SyncSalesforceBooksJob < ApplicationJob
  queue_as :schools
  sidekiq_options lock: :while_executing,
                  on_conflict: :reject

  def perform(*args)
    sf_books = OpenStax::Salesforce::Remote::Book.all

    sf_books.each do |sf_book|
      Book.cache_local(sf_book)
    end
    JobsHelper.delete_objects_not_in_salesforce('Book', sf_books)
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create(name: 'Salesforce Book sync - every 1 day', cron: '0 0 * * *', class: 'SyncSalesforceBooksJob')
end
