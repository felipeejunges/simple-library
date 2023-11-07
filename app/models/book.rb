# frozen_string_literal: true

class Book < ApplicationRecord
  
  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true


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
