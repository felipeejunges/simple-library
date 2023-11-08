# frozen_string_literal: true

class Api::V1::Book::DetailsController < Api::V1::ApplicationController
  before_action :set_book
  before_action :set_detail, only: %i[show update destroy]

  # GET /api/v1/books/1 or /api/v1/books/1.json
  def show; end

  # POST /books/1/details or /books/1/details.json
  def create
    @detail = @book.details.new(detail_params)

    if @detail.save
      puts "\n\n\n\n >>> DETAIL: #{@detail.inspect} <<<\n\n\n\n"
      render :show, status: :created, location: @detail
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  def update
    if @detail.update(detail_params)
      render :show, status: :ok, location: @detail
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/1/details/1 or /books/1/details/1.json
  def destroy
    if @detail.destroy
      head :no_content
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
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
