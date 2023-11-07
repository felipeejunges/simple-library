# frozen_string_literal: true

class Book < ApplicationRecord
  has_many :details
  has_many :borroweds

  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true

  scope :search, lambda { |query|
    joins(:details).where('books.title LIKE ? OR books.isbn LIKE ? OR book_details.description LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
  }

  def authors
    details.where(name: :author).pluck(:description)
  end

  def genres
    details.where(name: :genre).pluck(:description)
  end

  def publishers
    details.where(name: :publisher).pluck(:description)
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
