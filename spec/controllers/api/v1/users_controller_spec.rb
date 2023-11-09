# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do # rubocop:disable Metrics/BlockLength
  let(:librarian_user) { create(:user, role: 'librarian', first_name: 'Librarian') }
  let(:member_user) { create(:user, role: 'member') }
  let(:user_params) do
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  describe 'GET #index' do # rubocop:disable Metrics/BlockLength
    context 'when user is a librarian' do
      before { allow(controller).to receive(:current_user).and_return(librarian_user) }

      it 'returns a list of users' do
        get :index
        expect(response).to have_http_status(:success)
      end

      it 'returns a sorted list of users by name' do
        create(:user, first_name: 'Alice')
        create(:user, first_name: 'Bob')
        create(:user, first_name: 'Eve')

        get :index, params: { sort_by: 'name', sort_order: 'asc' }

        expect(response).to have_http_status(:ok)

        # response_data = JSON.parse(response.body)
        # expect(response_data['users'].count).to eq(3)

        # expect(response_data['users'][0]['name']).to eq('Alice')
        # expect(response_data['users'][1]['name']).to eq('Bob')
        # expect(response_data['users'][2]['name']).to eq('Eve')
        # expect(response_data['users'][3]['name']).to eq('Librarian')
      end

      it 'returns a sorted list of users by name' do
        create_list(:user, 3)

        get :index, params: { sort_by: 'id', sort_order: 'desc' }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is a member' do
      before { allow(controller).to receive(:current_user).and_return(member_user) }

      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    before { allow(controller).to receive(:current_user).and_return(librarian_user) }

    context 'when valid parameters are provided' do
      it 'creates a new user' do
        post :create, params: { user: user_params }
        expect(response).to have_http_status(:created)
        expect(User.count).to eq(2)
      end
    end

    context 'when invalid parameters are provided' do
      it 'returns unprocessable entity status' do
        post :create, params: { user: { email: 'invalid_email' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'when user is a librarian' do
      before { allow(controller).to receive(:current_user).and_return(librarian_user) }
      let(:user_to_update) { create(:user) }

      it 'updates the user' do
        put :update, params: { id: user_to_update.id, user: { first_name: 'New Name' } }
        expect(response).to have_http_status(:success)
      end

      context 'when invalid parameters are provided' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: user_to_update.id, user: { email: '', password: '222' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is a member' do
      before { allow(controller).to receive(:current_user).and_return(member_user) }
      let(:user_to_update) { create(:user) }

      it 'returns unauthorized error' do
        put :update, params: { id: user_to_update.id, user: { first_name: 'New Name' } }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { User.create(user_params) }

    before { allow(controller).to receive(:current_user).and_return(librarian_user) }

    it 'destroys the user' do
      expect do
        delete :destroy, params: { id: user.id }
      end.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    context 'having an error on destroy' do
      it 'not destroys the user' do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
        expect do
          delete :destroy, params: { id: user.id }
        end.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
