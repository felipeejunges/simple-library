# frozen_string_literal: true

class Book::DetailsController < ApplicationController
  before action :set_book
  before_action :set_detail, only: %i[show edit update destroy]

  # GET /books/1/details or /books/1/details.json
  def index
    authorize Book::Detail

    @details = @books.details.all
    sort_details
    @pagy, @details = pagy(@details)

    render(partial: 'details/table', locals: { details: @details })
  end

  # GET /books/1/books/1/details1 or /books/1/books/1/details1.json
  def show; end

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
      redirect_to detail_url(@detail)
    else
      flash[:error] = 'Detail not created'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @detail.update(detail_params)
      flash[:success] = 'Detail was successfully updated.'
      redirect_to detail_url(@detail)
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
    params.require(:detail).permit(:name, :description)
  end

  def allow_sort
    %w[name description].include?(params[:sort_by].to_s)
  end

  def sort_details
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = { params[:sort_by].to_sym => sort_order }

    @details = @details.order(sort)
  end
end
