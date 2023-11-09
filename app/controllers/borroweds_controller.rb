# frozen_string_literal: true

class BorrowedsController < ApplicationController
  def return_book
    @borrowed = Borrowed.find(params[:borrowed_id])
    authorize @borrowed

    flash[:error] = 'An error happend during return' unless @borrowed.return_book
    redirect_to params[:from_user].present? ? user_path(@borrowed.user) : book_path(@borrowed.book)
  end
end
