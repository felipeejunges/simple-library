# frozen_string_literal: true

class Book::DetailDetailsController < ApplicationController
  before action :set_book
  before_action :set_detail, only: %i[show edit update destroy]

  # GET /details or /details.json
  def index
    authorize Book::Detail

    @details = @books.details.all
    sort_details
    @pagy, @details = pagy(@details)

    render(partial: 'details/table', locals: { details: @details })
  end

  # GET /details/1 or /details/1.json
  def show; end

  # GET /details/new
  def new
    authorize Book::Detail
    @detail = @book.details.new
  end

  # POST /details or /details.json
  def create
    @detail = @book.details.new(detail_params)

    respond_to do |format|
      if @detail.save
        format.html do
          flash[:success] = 'Book::Detail was successfully created.'
          redirect_to detail_url(@detail)
        end
        format.json { render :show, status: :created, location: @detail }
      else
        format.html do
          flash[:error] = 'Book::Detail not created'
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @detail.update(detail_params)
        format.html do
          flash[:success] = 'Book::Detail was successfully updated.'
          redirect_to detail_url(@detail)
        end
        format.json { render :show, status: :ok, location: @detail }
      else
        format.html do
          flash[:error] = 'Book::Detail not updated'
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /details/1 or /details/1.json
  def destroy
    respond_to do |format|
      if @detail.destroy
        format.html do
          flash[:success] = 'Book::Detail was successfully destroyed.'
          redirect_to details_url
        end
        format.json { head :no_content }
      else
        format.html do
          flash[:error] = 'Book::Detail not deleted'
          redirect_to details_url
        end
        format.json { render json: @detail.errors, status: :unprocessable_entity }
      end
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
    %w[id title isbn].include?(params[:sort_by].to_s)
  end

  def sort_details
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = { params[:sort_by].to_sym => sort_order }

    @details = @details.order(sort)
  end
end
