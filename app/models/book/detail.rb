# frozen_string_literal: true

class Book::Detail < ApplicationRecord
  belongs_to :book

  validates_presence_of :name, :description

  enum name: {
    author: 1,
    genre: 2,
    publisher: 3
  }
end

# == Schema Information
#
# Table name: book_details
#
#  id          :integer          not null, primary key
#  name        :integer
#  description :string
#  book_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_book_details_on_book_id  (book_id)
#
