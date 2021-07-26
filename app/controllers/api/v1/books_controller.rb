class Api::V1::BooksController < Api::V1::BaseController
  # GET /books
  def index
    @books = Book.paginate(page: params[:page], per_page: 20)
    render json: @books
  end

  # GET /books/:id
  def show
    @book = Book.find_by!(salesforce_id: params[:id])
    render json: @book
  end

  # GET /books/search?name
  def search
    @book = Book.search(params[:name])
    render json: @book
  end
end
