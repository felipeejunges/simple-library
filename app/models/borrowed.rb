# frozen_string_literal: true

class Borrowed < ApplicationRecord
  belongs_to :user
  belongs_to :book

  scope :late, lambda {
    not_returned
      .where('borrowed_at < ?', 2.weeks.ago)
  }

  scope :not_returned, lambda {
    where(returned_at: nil)
  }

  def self.total_borroweds
    not_returned.count
  end

  def self.total_lates
    Borrowed.late.count
  end

  def late?
    returned_at.blank? && borrowed_at < 2.weeks.ago
  end
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
