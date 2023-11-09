# frozen_string_literal: true

class Api::V1::DashboardsController < Api::V1::ApplicationController
  def index
    @hash = {}
    current_user.member? || params[:my_dashboard] ? member_dashboard : librarian_dashboard
    render json: @hash, status: :ok
  end

  private

  def librarian_dashboard
    @hash[:total_books] = Book.total_books
    @hash[:total_uniq_books] = Book.count
    @hash[:total_borroweds] = Borrowed.total_borroweds
    @hash[:total_due] = Borrowed.total_lates
    @hash[:users_with_overdue_books] = User.with_overdue_books
  end

  def member_dashboard
    @hash[:borrowed_books] = current_user.borroweds.order(:borrowed_at).map do |borrowed|
      book = borrowed.book
      {
        book_id: book.id,
        isbn: book.isbn,
        title: book.title,
        series: book.series,
        volume: book.volume,
        borrowed_at: borrowed.borrowed_at,
        returned_at: borrowed.returned_at,
        late: borrowed.late?,
        due_date: borrowed.expected_return
      }
    end
  end
end
