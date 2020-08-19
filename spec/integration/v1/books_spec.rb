require "swagger_helper"

RSpec.describe "api/v1/books", type: :request do
  path "/api/v1/books" do
    get "List all Books" do
      tags "Books"
      consumes "application/json"
      parameter name: :book, in: :body, schema: {
          type: :object,
          properties: {
              salesforce_id: { type: :string },
              name: { type: :string }
          },
          required: ["salesforce_id", "name"],
      }
      response "200", "books retrieved" do
        let(:book) { FactoryBot.create :book }
        run_test!
      end
    end
  end

  path "/api/v1/books/{id}" do

    get "Return one book" do
      tags "Books"
      consumes "application/json"
      parameter name: :id, in: :path, type: :string

      response "200", "book found" do
        schema type: :object,
               properties: {
                   salesforce_id: { type: :string },
                   name: { type: :string }
               },
               required: ["salesforce_id", "name"]

        let(:id) { Book.create(name: 'College Algebra', salesforce_id: 'AZ44335AQ').id }
        run_test!
      end

      response '404', 'book not found' do
        let(:id) { 25 }
        run_test!
      end
    end
  end
end