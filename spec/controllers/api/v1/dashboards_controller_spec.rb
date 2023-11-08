require 'rails_helper'

RSpec.describe Api::V1::DashboardsController, type: :controller do
  let(:librarian_user) { FactoryBot.create(:user, role: 'librarian') }
  let(:member_user) { FactoryBot.create(:user, role: 'member') }
  let(:book) { FactoryBot.create(:book) }
  let(:borrowed_book) { FactoryBot.create(:borrowed, user: member_user, book:) }

  describe 'GET #index for Librarian' do
    before do
      allow(controller).to receive(:current_user).and_return(librarian_user)
    end

    it 'returns librarian dashboard data' do
      get :index
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['total_books']).to be_an(Integer)
      expect(json_response['total_uniq_books']).to be_an(Integer)
      expect(json_response['total_borroweds']).to be_an(Integer)
      expect(json_response['total_due']).to be_an(Integer)
      expect(json_response['users_with_overdue_books']).to be_an(Array)
    end
  end

  describe 'GET #index for Member' do
    before do
      allow(controller).to receive(:current_user).and_return(member_user)
    end

    it 'returns member dashboard data' do
      get :index
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['borrowed_books']).to be_an(Array)
    end
  end
end
