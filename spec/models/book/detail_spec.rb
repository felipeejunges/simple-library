# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book::Detail, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  describe 'associations' do
    it { should belong_to(:book) }
  end
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
