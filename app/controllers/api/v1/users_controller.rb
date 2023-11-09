# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :set_user, only: %i[show update destroy]

  ALLOWED_SORTS = %w[id name email role].freeze

  # GET /users or /users.json
  def index
    authorize User

    @users = sort(User.all, ALLOWED_SORTS)
    @pagy, @users = pagy(@users)
    @pagination = pagy_metadata(@pagy)
  end

  # GET /api/v1/users/1 or /api/v1/users/1.json
  def show; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params.merge(password_params))
    authorize @user
    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    all_params = user_params
    all_params.delete(:role) unless current_user.librarian?
    all_params.merge!(password_params) if password_params[:password].present? && password_params[:password_confirmation].present?
    if @user.update(all_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/1 or /api/v1/users/1.json
  def destroy
    if @user.destroy
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
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

  def sort(objects, alloweds)
    return objects unless allow_sort(alloweds)

    sort_order = params[:sort_order].upcase == 'DESC' ? 'DESC' : 'ASC'
    sortable = if params[:sort_by] == 'name'
                 { first_name: sort_order, last_name: sort_order }
               else
                 { params[:sort_by].to_sym => sort_order }
               end

    objects.order(sortable)
  end
end
