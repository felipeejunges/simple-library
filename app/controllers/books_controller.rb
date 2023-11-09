# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_books, only: %i[index list]
  before_action :set_book, only: %i[show edit update destroy borrow]

  ALLOWED_SORTS = %w[id title isbn].freeze

  # GET /books or /books.json
  def index; end

  def list
    render(partial: 'books/table', locals: { books: @books })
  end

  # GET /books/1 or /books/1.json
  def show; end

  # GET /books/new
  def new
    authorize Book
    @book = Book.new
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    if @book.save
      flash[:success] = 'Book was successfully created.'
      redirect_to book_url(@book)
    else
      flash[:error] = 'Book not created'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      flash[:success] = 'Book was successfully updated.'
      redirect_to book_url(@book)
    else
      flash[:error] = 'Book not updated'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    if @book.destroy
      flash[:success] = 'Book was successfully destroyed.'
    else
      flash[:error] = 'Book not deleted'
    end
    redirect_to books_url
  end

  def borrow
    user = current_user.librarian? ? User.find(params[:user_id]) : current_user
    borrowed = @book.borrow(user)
    if borrowed
      flash[:success] = 'Book was successfully borrowed.'
    else
      flash[:error] = 'Book was not borrowed'
    end

    redirect_to book_url(@book)
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

  def set_books
    authorize Book

    @books = Book.search(params[:query])
    @books = sort(@books, ALLOWED_SORTS)
    @pagy, @books = pagy(@books)
  end
end
