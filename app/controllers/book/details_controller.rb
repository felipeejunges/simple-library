# frozen_string_literal: true

class Book::DetailsController < ApplicationController
  before_action :set_book
  before_action :set_detail, only: %i[show edit update destroy]

  ALLOWED_SORTS = %w[id name description].freeze

  # GET /books/1/details or /books/1/details.json
  def index
    authorize Book::Detail

    @details = sort(@book.details, ALLOWED_SORTS)

    render(partial: 'book/details/table', locals: { details: @details })
  end

  # GET /books/1/books/1/detailsnew
  def new
    authorize Book::Detail
    @detail = @book.details.new
  end

  # POST /books/1/details or /books/1/details.json
  def create
    @detail = @book.details.new(detail_params)

    if @detail.save
      flash[:success] = 'Detail was successfully created.'
      redirect_to book_url(@detail.book)
    else
      flash[:error] = 'Detail not created'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @detail.update(detail_params)
      flash[:success] = 'Detail was successfully updated.'
      redirect_to book_url(@detail.book.id)
    else
      flash[:error] = 'Detail not updated'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /books/1/books/1/details1 or /books/1/books/1/details1.json
  def destroy
    if @detail.destroy
      flash[:success] = 'Detail was successfully destroyed.'
    else
      flash[:error] = 'Detail not deleted'
    end
    redirect_to details_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_detail
    @detail = @book.details.find(params[:id])
    authorize @detail
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  # Only allow a list of trusted parameters through.
  def detail_params
    params.require(:book_detail).permit(:name, :description)
  end
end
