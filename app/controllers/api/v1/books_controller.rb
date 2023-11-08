# frozen_string_literal: true

class Api::V1::BooksController < Api::V1::ApplicationController
  before_action :set_book, only: %i[show update destroy borrow]

  # GET /books or /books.json
  def index
    authorize Book

    @books = Book.all
    sort_books
    @pagy, @books = pagy(@books)
    @pagination = pagy_metadata(@pagy)
  end

  def search
    authorize Book
    @books = Book.search(params[:query])
    sort_books
    @pagy, @books = pagy(@books)
    render :index
  end

  # GET /api/v1/books/1 or /api/v1/books/1.json
  def show; end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    if @book.save
      details_params[:details].each do |detail|
        @book.details.create(name: detail[:name], description: detail[:description])
      end
      render :show, status: :created, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render :show, status: :ok, location: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/books/1 or /api/v1/books/1.json
  def destroy
    if @book.destroy
      head :no_content
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def borrow
    user = User.find(users_params[:id])
    borrowed = @book.borrow(user)
    if borrowed
      render json: { expected_return: borrowed.expected_return, borrowed_id: borrowed.id }, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:book_id] || params[:id])
    authorize @book
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :isbn, :synopsis, :copies, :language, :pages, :series, :volume)
  end

  def details_params
    params.require(:book).require(:details).permit(details: %i[name description])
  end

  def users_params
    params.require(:user).permit(:id)
  end

  def allow_sort
    %w[id title isbn].include?(params[:sort_by].to_s)
  end

  def sort_books
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = { params[:sort_by].to_sym => sort_order }

    @books = @books.order(sort)
  end
end
