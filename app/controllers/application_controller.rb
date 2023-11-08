# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :require_login

  private

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to '/login' }
      format.json { render json: { error: 'Not authenticated' } }
    end
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.env['HTTP_REFERER'])
  end
end
