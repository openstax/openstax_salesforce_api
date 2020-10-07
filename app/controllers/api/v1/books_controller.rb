class Api::V1::BooksController < ApplicationController
  before_action :authorize_request

  # GET /books
  def index
    @books = Book.paginate(page: params[:page], per_page: 20)
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
