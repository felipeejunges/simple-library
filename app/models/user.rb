# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :borroweds
  has_many :books, through: :borroweds

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  enum role: {
    member: 1,
    librarian: 2
  }, _default: 'member'

  def self.with_overdue_books
    Borrowed.late.joins(:user).pluck(:user_id, :first_name, :last_name).uniq
  end

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  email            :string
#  salt             :string
#  crypted_password :string
#  role             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
