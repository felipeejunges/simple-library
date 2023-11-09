# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BorrowedsController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:librarian_user) { create(:user, role: 'librarian') }
  let(:member_user) { create(:user, role: 'member') }
  let(:book) { create(:book) }
  let(:borrowed) { create(:borrowed, user: member_user, book:) }

  describe 'GET #index for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'returns a list of borroweds' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index for Member' do
    before do
      allow(controller).to receive(:current_user).and_return(member_user)
    end

    it 'returns a list of borroweds' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH #return_book' do # rubocop:disable Metrics/BlockLength
    let(:book) { create(:book) }
    let(:borrowed_book) { create(:borrowed, user: member_user, book:) }

    describe 'for Librarian' do
      context 'when librarian user returns a borrowed book' do
        before do
          allow(controller).to receive(:current_user).and_return(librarian_user)
          borrowed_book
        end

        it 'returns success status' do
          patch :return_book, params: { borrowed_id: borrowed_book.id }
          expect(response).to have_http_status(:ok)
        end

        it 'marks the book as returned' do
          expect { patch :return_book, params: { borrowed_id: borrowed_book.id } }
            .to change { borrowed_book.reload.returned_at }.from(nil)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'for Member' do
      context 'when member user tries to return a borrowed book' do
        before do
          allow(controller).to receive(:current_user).and_return(member_user)
        end

        it 'returns forbidden status' do
          patch :return_book, params: { borrowed_id: borrowed_book.id }
          expect(response).to have_http_status(:unauthorized)
        end

        it 'does not mark the book as returned' do
          expect { patch :return_book, params: { borrowed_id: borrowed_book.id } }
            .not_to(change { borrowed_book.reload.returned_at })
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
