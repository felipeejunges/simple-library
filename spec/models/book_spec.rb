# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book, type: :model do # rubocop:disable Metrics/BlockLength
  let(:book) { create(:book, copies: 3) }
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:copies) }
    it { should validate_uniqueness_of(:isbn) }
  end

  describe 'scopes' do
    describe '.search' do
      it 'returns books matching the provided query' do
        book1 = create(:book, title: 'Harry Potter and the Sorcerer\'s Stone')
        book2 = create(:book, title: 'Lord of the Rings: Fellowship of the Ring')

        results = Book.search('Harry Potter')
        expect(results).to include(book1)
        expect(results).not_to include(book2)
      end
    end
  end

  describe 'associations' do
    it { should have_many(:borroweds) }
    it { should have_many(:details) }
  end

  describe 'class methods' do
    describe '.total_books' do
      it 'returns the total number of books' do
        book
        expect(Book.total_books).to eq(3)
      end
    end
  end

  describe 'methods' do # rubocop:disable Metrics/BlockLength
    describe '#publishers' do
      it 'returns the list of publishers associated with the book' do
        publisher = create(:book_detail, name: :publisher, book:)
        expect(book.publishers).to eq([publisher.description])
      end
    end

    describe '#genres' do
      it 'returns the list of genres associated with the book' do
        genre = create(:book_detail, name: :genre, book:)
        expect(book.genres).to eq([genre.description])
      end
    end

    describe '#authors' do
      it 'returns the list of authors associated with the book' do
        author = create(:book_detail, name: :author, book:)
        expect(book.authors).to eq([author.description])
      end
    end

    describe '#available?' do
      it 'returns true if there are available copies' do
        create(:borrowed, book:)
        expect(book.available?).to be_truthy
      end

      it 'returns false if there are no available copies' do
        3.times { create(:borrowed, book:) }
        expect(book.available?).to be_falsy
      end
    end

    describe '#already_borrowed_by_this_user?' do
      context 'when the book is already borrowed by the user' do
        it 'returns true' do
          create(:borrowed, book:, user:)
          expect(book.already_borrowed_by_this_user?(user)).to be_truthy
        end
      end

      context 'when the book is not borrowed by the user' do
        it 'returns false' do
          another_user = create(:user)
          create(:borrowed, book:, user: another_user)
          expect(book.already_borrowed_by_this_user?(user)).to be_falsy
        end
      end
    end

    describe '#borrow' do
      it 'creates a new borrowed record for the user' do
        expect { book.borrow(user) }.to change(Borrowed, :count).by(1)
      end

      it 'returns the created borrowed record' do
        borrowed = book.borrow(user)
        expect(borrowed).to be_a(Borrowed)
        expect(borrowed).to be_persisted
        expect(borrowed.book).to eq(book)
        expect(borrowed.user).to eq(user)
      end

      it 'does not allow borrowing if no available copies' do
        book.update(copies: 0)
        expect { book.borrow(user) }.to_not change(Borrowed, :count)
      end

      it 'does not allow borrowing if no available copies' do
        allow_any_instance_of(Borrowed).to receive(:save).and_return(false)
        expect { book.borrow(user) }.to_not change(Borrowed, :count)
      end
    end
  end
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
#  language   :string
#  pages      :integer
#  series     :string
#  volume     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
