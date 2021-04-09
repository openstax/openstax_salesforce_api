class Api::V1::BooksController < Api::V1::BaseController
  # GET /books
  def index
    if params['name'].present?
      @books = Book.where(name: params['name'])
      if @books.blank?
        render json: {
            name: params['name'],
            error: 'book not found'
        }, status: :not_found and return
      end
    else
      @books = Book.paginate(page: params[:page], per_page: 20)
    end
    render json: @books
  end

  # GET /books/:id
  def show
    @book = Book.find_by!(salesforce_id: params[:id])
    render json: @book, status: :ok
  end
end
