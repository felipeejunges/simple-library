# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  def name
    "#{first_name} #{last_name}"
  end
end

# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string
#  last_name        :string
#  email            :string
#  salt             :string
#  crypted_password :string
#  document         :string
#  pub_id           :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_pub_id  (pub_id)
#
# Foreign Keys
#
#  fk_rails_...  (pub_id => pubs.id)
#
