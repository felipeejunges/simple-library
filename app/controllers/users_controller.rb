# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_users, only: %i[index list]
  before_action :set_user, only: %i[show destroy]

  # GET /users or /users.json
  def index
    respond_to do |format|
      format.html {}
      format.json { render json: current_user.name }
    end
  end

  def list
    render(partial: 'users/table', locals: { users: @users })
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :salt, :crypted_password)
  end

  def set_users
    # authorize User

    @users = User.all
    sort_users
    @pagy, @users = pagy(@users)
  end

  def allow_sort
    %w[id name email].include?(params[:sort_by].to_s)
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
