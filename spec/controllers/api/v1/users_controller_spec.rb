require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:librarian_user) { create(:user, role: 'librarian') }
  let(:member_user) { create(:user, role: 'member') }

  describe 'GET #index' do
    context 'when user is a librarian' do
      before { allow(controller).to receive(:current_user).and_return(librarian_user) }

      it 'returns a list of users' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is a member' do
      before { allow(controller).to receive(:current_user).and_return(member_user) }

      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is a librarian' do
      before { allow(controller).to receive(:current_user).and_return(librarian_user) }
      let(:user_to_update) { FactoryBot.create(:user) }

      it 'updates the user' do
        put :update, params: { id: user_to_update.id, user: { first_name: 'New Name' } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is a member' do
      before { allow(controller).to receive(:current_user).and_return(member_user) }
      let(:user_to_update) { FactoryBot.create(:user) }

      it 'returns unauthorized error' do
        put :update, params: { id: user_to_update.id, user: { first_name: 'New Name' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
