# frozen_string_literal: true

class Api::V1::UserSessionsController < Api::V1::ApplicationController
  skip_before_action :require_login

  def authenticate
    token = login_and_issue_token(params[:user][:email], params[:user][:password])
    if token
      render json: {
        token:
      }
    else
      render json: { error: 'Invalid email or password' }, status: :unprocessable_entity
    end
  end
end
