# frozen_string_literal: true

class Api::V1::BorrowedsController < Api::V1::ApplicationController
  def index
    authorize Borrowed

    @borroweds = Borrowed.all
    sort_borroweds
    @pagy, @borroweds = pagy(@borroweds)
    @pagination = pagy_metadata(@pagy)
  end

  def return_book
    @borrowed = Borrowed.find(params[:borrowed_id])
    authorize @borrowed
    if @borrowed.return_book
      render :show, status: :ok, location: @borrowed
    else
      render json: @borrowed.errors, status: :unprocessable_entity
    end
  end

  private

  def allow_sort
    %w[id].include?(params[:sort_by].to_s)
  end

  def sort_borroweds
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = { params[:sort_by].to_sym => sort_order }

    @borroweds = @borroweds.order(sort)
  end
end