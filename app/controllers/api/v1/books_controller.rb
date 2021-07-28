class Api::V1::BooksController < Api::V1::BaseController
  # routes for this controller have been commented out and tests removed until the API is needed
  # The API is not being used.

  # GET /books/:id
  def show
    @book = Book.find_by!(salesforce_id: params[:id])
    render json: @book, status: :ok
  end

  # GET /books/search?name
  def search
    @book = Book.search(params[:name])
    render json: @book, status: :ok
  end
end
