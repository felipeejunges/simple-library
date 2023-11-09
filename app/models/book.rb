# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :details
  has_many :borroweds

  validates :title, :isbn, :copies, presence: true
  validates :isbn, uniqueness: true

  scope :search, lambda { |query|
    left_joins(:details).where('books.title LIKE ? OR books.isbn LIKE ? OR book_details.description LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%").distinct(:id)
  }

  def self.total_books
    Book.sum(:copies)
  end

  def authors
    details.where(name: :author).order(:description).pluck(:description)
  end

  def genres
    details.where(name: :genre).order(:description).pluck(:description)
  end

  def publishers
    details.where(name: :publisher).order(:description).pluck(:description)
  end

  def available?
    borroweds.not_returned.count < copies
  end

  def already_borrowed_by_this_user?(user)
    borroweds.not_returned.where(user_id: user.id).any?
  end

  def borrow(user)
    unless available?
      errors.add(:base, 'Not available')
      return false
    end

    if already_borrowed_by_this_user?(user)
      errors.add(:base, 'Already borrowed by this user')
      return false
    end

    borrowed = borroweds.new(borrowed_at: Date.current, user_id: user.id)
    return borrowed if borrowed.save

    errors.add(:base, 'Unexpected Error')
    false
  end
end

# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string
#  isbn       :string
#  synopsis   :string
#  copies     :integer
#  language   :string
#  pages      :integer
#  series     :string
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
