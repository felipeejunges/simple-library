# frozen_string_literal: true

class Borrowed < ApplicationRecord
end

# == Schema Information
#
# Table name: borroweds
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  book_id     :integer
#  borrowed_at :datetime
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_borroweds_on_book_id  (book_id)
#  index_borroweds_on_user_id  (user_id)
#
