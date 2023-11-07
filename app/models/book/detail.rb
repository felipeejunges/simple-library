# frozen_string_literal: true

class Book::Detail < ApplicationRecord
end

# == Schema Information
#
# Table name: book_details
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  book_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_book_details_on_book_id  (book_id)
#
