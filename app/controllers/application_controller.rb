# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  # protect_from_forgery with: :exception, if: proc { |c| c.request.format != 'application/json' }
  # protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }
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
