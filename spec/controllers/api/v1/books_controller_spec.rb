# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:librarian_user) { create(:user, role: 'librarian') }
  let(:member_user) { create(:user, role: 'member') }
  let(:book) { create(:book) }
  let(:borrowed_book) { create(:borrowed, user_id: member_user.id).book }

  describe 'GET #index for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'returns a list of books' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns a sorted list of users by id' do
      create_list(:book, 3)

      get :index, params: { sort_by: 'id', sort_order: 'desc' }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #index for Member' do
    before do
      allow(controller).to receive(:current_user).and_return(member_user)
    end

    it 'returns a list of books' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #search' do
    before do
      allow(controller).to receive(:current_user).and_return(member_user)
    end
    let!(:book1) { create(:book, title: 'Harry Potter and the Philosopher\'s Stone') }
    let!(:book2) { create(:book, title: 'The Hobbit') }
    let!(:book3) { create(:book, title: 'Lord of the Rings') }

    context 'when searching for books' do
      it 'returns a list of books matching the search query' do
        get :search, params: { query: 'Harry Potter' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when no books match the search query' do
      it 'returns an empty list' do
        get :search, params: { query: 'Narnia' }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #borrow' do
    context 'when librarian borrows a book' do
      it 'successfully borrows the book' do
        allow(controller).to receive(:current_user).and_return(librarian_user)
        post :borrow, params: { book_id: book.id, user: { id: member_user.id } }

        expect(response).to have_http_status(:ok)
        expect(book.borroweds.any?).to be(true)
      end
    end

    context 'when member borrows a book' do
      it 'successfully borrows the book' do
        allow(controller).to receive(:current_user).and_return(member_user)
        post :borrow, params: { book_id: book.id }

        expect(response).to have_http_status(:ok)
        expect(book.borroweds.any?).to be(true)
      end
    end

    context 'when book is already borrowed' do
      it 'returns an error' do
        allow(controller).to receive(:current_user).and_return(member_user)
        post :borrow, params: { book_id: borrowed_book.id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do # rubocop:disable Metrics/BlockLength
    context 'when librarian deletes a book' do
      before do
        allow(controller).to receive(:current_user).and_return(librarian_user)
      end
      it 'successfully deletes the book' do
        delete :destroy, params: { id: book.id }

        expect(response).to have_http_status(:no_content)
      end

      context 'having an error on destroy' do
        it 'not destroys the user' do
          allow_any_instance_of(Book).to receive(:destroy).and_return(false)
          book
          expect do
            delete :destroy, params: { id: book.id }
          end.to change(Book, :count).by(0)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when member tries to delete a book' do
      it 'returns an error' do
        allow(controller).to receive(:current_user).and_return(member_user)
        delete :destroy, params: { id: book.id }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when librarian updates a book' do
      before do
        allow(controller).to receive(:current_user).and_return(librarian_user)
      end
      it 'successfully updates the book' do
        patch :update, params: { id: book.id, book: { title: 'New Title' } }

        expect(response).to have_http_status(:ok)
      end

      it 'do not updates a book' do
        post :update, params: { id: book.id, book: { title: 'Failure', isbn: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when member tries to update a book' do
      it 'returns an error' do
        allow(controller).to receive(:current_user).and_return(member_user)
        patch :update, params: { id: book.id, book: { title: 'New Title' } }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'creates a new book' do
      post :create, params: { book: attributes_for(:book) }
      expect(response).to have_http_status(:created)
    end

    it 'do not creates a new book' do
      post :create, params: { book: { title: 'Failure' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'creates a new book with details' do
      params = attributes_for(:book)
      params[:details] = [name: 'author', description: 'R. Spec']
      post :create, params: { book: params }
      expect(response).to have_http_status(:created)
    end
  end
end
