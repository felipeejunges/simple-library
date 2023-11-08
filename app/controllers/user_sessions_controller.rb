# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :require_login
  before_action :redirect_already_logged, only: %i[signin authenticate]
  def signin; end

  def authenticate
    user = login(params[:user][:email], params[:user][:password])
    if user
      flash[:success] = "Welcome, #{current_user.name}"
      redirect_to root_path
    else
      flash[:alert] = 'Invalid email or password'
      render :signin, status: :unprocessable_entity
    end
  end

  def signout
    logout
    redirect_to login_path
  end

  private

  def redirect_already_logged
    return if current_user.blank?

    redirect_to '/'
  end
end
