require 'rails_helper'

RSpec.describe Borrowed, type: :model do # rubocop:disable Metrics/BlockLength
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:book_id) }
    it { should validate_presence_of(:borrowed_at) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'scopes' do
    context '.not_returned' do
      let!(:returned_borrowed) { create(:borrowed, returned_at: Time.current) }
      let!(:not_returned_borrowed) { create(:borrowed, returned_at: nil) }

      it 'returns only not returned borroweds' do
        expect(Borrowed.not_returned).to contain_exactly(not_returned_borrowed)
      end
    end

    context '.late' do
      let!(:late_borrowed) { create(:borrowed, borrowed_at: 3.weeks.ago) }
      let!(:not_late_borrowed) { create(:borrowed, borrowed_at: 1.week.ago) }

      it 'returns late borroweds' do
        expect(Borrowed.late).to contain_exactly(late_borrowed)
      end
    end
  end

  describe 'class methods' do
    context '.total_borroweds' do
      it 'returns the total number of borroweds' do
        create_list(:borrowed, 3)
        expect(Borrowed.total_borroweds).to eq(3)
      end
    end

    context '.total_lates' do
      it 'returns the total number of overdue borroweds' do
        overdue_borroweds = create_list(:borrowed, 2, borrowed_at: 3.weeks.ago, returned_at: nil)
        create_list(:borrowed, 3, borrowed_at: 1.week.ago, returned_at: Time.current)

        expect(Borrowed.total_lates).to eq(overdue_borroweds.count)
      end
    end
  end

  describe 'methods' do # rubocop:disable Metrics/BlockLength
    describe '#late?' do
      context 'when borrowed_at is more than 2 weeks ago and not returned' do
        let(:borrowed) { create(:borrowed, borrowed_at: 3.weeks.ago, returned_at: nil) }

        it 'returns true' do
          expect(borrowed.late?).to be(true)
        end
      end

      context 'when borrowed_at is less than 2 weeks ago and not returned' do
        let(:borrowed) { create(:borrowed, borrowed_at: 1.week.ago, returned_at: nil) }

        it 'returns false' do
          expect(borrowed.late?).to be(false)
        end
      end

      context 'when the book is returned' do
        let(:borrowed) { create(:borrowed, borrowed_at: 3.weeks.ago, returned_at: 1.week.ago) }

        it 'returns false' do
          expect(borrowed.late?).to be(false)
        end
      end
    end

    describe '#expected_return' do
      let(:borrowed) { create(:borrowed, borrowed_at: Time.current) }

      it 'returns the expected return date' do
        expect(borrowed.expected_return).to eq(borrowed.borrowed_at + 2.weeks)
      end
    end

    describe '#return_book' do
      let(:borrowed) { create(:borrowed, returned_at: nil) }

      it 'sets the returned_at attribute and saves the borrowed instance' do
        expect { borrowed.return_book }.to change { borrowed.returned_at }.from(nil)
        expect(borrowed).to be_valid
      end

      context 'when the book is already returned' do
        before { borrowed.update(returned_at: 1.day.ago) }

        it 'adds an error to the returned_at attribute' do
          expect { borrowed.return_book }.not_to(change { borrowed.returned_at })
          expect(borrowed.errors[:returned_at]).to include('Already Returned')
        end
      end
    end
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
