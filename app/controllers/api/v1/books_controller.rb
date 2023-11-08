# frozen_string_literal: true

class Api::V1::BooksController < Api::V1::ApplicationController
  before_action :set_book, only: %i[show update destroy]

  # GET /books or /books.json
  def index
    authorize Book

    @books = Book.all
    sort_books
    @pagy, @books = pagy(@books)
  end

  # GET /books/1 or /books/1.json
  def show; end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    if @book.save
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

  # DELETE /books/1 or /books/1.json
  def destroy
    if @book.destroy
      head :no_content
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
    authorize @book
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :isbn, :synopsis, :copies)
  end

  def allow_sort
    %w[id title isbn].include?(params[:sort_by].to_s)
  end

  def sort_books
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = if params[:sort_by] == 'name'
             { first_name: sort_order, last_name: sort_order }
           else
             { params[:sort_by].to_sym => sort_order }
           end

    @books = @books.order(sort)
  end
end
