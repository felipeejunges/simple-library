# frozen_string_literal: true

class Book < ApplicationRecord
  
  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true


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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
