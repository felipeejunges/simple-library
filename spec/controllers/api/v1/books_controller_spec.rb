# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do  # rubocop:disable Metrics/BlockLength
  let(:librarian_user) { create(:user, role: 'librarian') }
  let(:member_user) { create(:user, role: 'member') }
  let(:book) { create(:book) }

  describe 'GET #index for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'returns a list of books' do
      get :index
      expect(response).to have_http_status(:success)
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

  describe 'POST #create for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'creates a new book' do
      post :create, params: { book: attributes_for(:book) }
      expect(response).to have_http_status(:created)
    end
  end
end
