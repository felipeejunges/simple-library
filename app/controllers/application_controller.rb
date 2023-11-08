# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  before_action :require_login

  private

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to '/login' }
      format.json { render json: { error: 'Not authenticated' } }
    end
  end
end
