# frozen_string_literal: true

class Api::V1::BorrowedsController < Api::V1::ApplicationController
  ALLOWED_SORTS = %w[id].freeze

  def index
    authorize Borrowed

    @borroweds = current_user.librarian? ? Borrowed.all : current_user.borroweds
    @borroweds = sort(@borroweds, ALLOWED_SORTS)
    @pagy, @borroweds = pagy(@borroweds)
    @pagination = pagy_metadata(@pagy)
  end

  def return_book
    @borrowed = Borrowed.find(params[:borrowed_id])
    authorize @borrowed

    render json: @borrowed.errors, status: :unprocessable_entity unless @borrowed.return_book
  end
end
