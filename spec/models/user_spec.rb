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

  describe 'methods' do
    let(:user) { create(:user) }

    it '#name returns the full name' do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end
end
