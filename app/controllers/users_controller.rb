# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_users, only: %i[index list]
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index; end

  def list
    render(partial: 'users/table', locals: { users: @users })
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    authorize User
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params.merge(password_params))

    if @user.save
      flash[:success] = 'User was successfully created.'
      redirect_to user_url(@user)
    else
      flash[:error] = 'User not created'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    all_params = user_params
    all_params.merge!(password_params) if password_params[:password].present? && password_params[:password_confirmation].present?
    if @user.update(all_params)
      flash[:success] = 'User was successfully updated.'
      redirect_to user_url(@user)
    else
      flash[:error] = 'User not updated'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.destroy
      flash[:success] = 'User was successfully destroyed.'
    else
      flash[:error] = 'User not deleted'
    end
    redirect_to users_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_users
    authorize User

    @users = User.all
    sort_users
    @pagy, @users = pagy(@users)
  end

  def allow_sort
    %w[id name email role].include?(params[:sort_by].to_s)
  end

  def sort_users
    return unless allow_sort

    sort_order = params[:sort_order] == 'DESC' ? 'DESC' : 'ASC'
    sort = if params[:sort_by] == 'name'
             { first_name: sort_order, last_name: sort_order }
           else
             { params[:sort_by].to_sym => sort_order }
           end

    @users = @users.order(sort)
  end
end
