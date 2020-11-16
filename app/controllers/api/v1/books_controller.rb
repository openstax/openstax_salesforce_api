class Api::V1::BooksController < ApplicationController

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
    begin
      @book = Book.find(params[:id])
      render json: @book, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: {
          error: e.to_s
      }, status: :not_found
    end
  end
end
