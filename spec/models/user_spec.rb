require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:password).is_at_least(3) }
  end

  describe 'associations' do
    it { should have_many(:borroweds) }
    it { should have_many(:books).through(:borroweds) }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(member: 1, librarian: 2) }
  end

  describe 'class methods' do
    context '.with_overdue_books' do
      it 'returns users with overdue books' do
        overdue_user = create(:user)
        non_overdue_user = create(:user)

        overdue_book = create(:book)
        non_overdue_book = create(:book)

        create(:borrowed, user: overdue_user, book: overdue_book, borrowed_at: 3.weeks.ago, returned_at: nil)
        create(:borrowed, user: non_overdue_user, book: non_overdue_book, borrowed_at: 1.week.ago)

        users_with_overdue_books = User.with_overdue_books

        expect(users_with_overdue_books).to include([overdue_user.id, overdue_user.first_name, overdue_user.last_name])
        expect(users_with_overdue_books).not_to include([non_overdue_user.id, non_overdue_user.first_name, non_overdue_user.last_name])
      end
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }

    it '#name returns the full name' do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
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
