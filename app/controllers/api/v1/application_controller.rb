# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  before_action :set_default_response_format
  skip_before_action :verify_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :raise_bad_request

  private

  def raise_bad_request
    render json: { error: 'Record not found' }, status: :not_found
  end

  def set_default_response_format
    request.format = :json
  end

  def not_authenticated
    render json: { error: 'Not authenticated' }, status: :unauthorized
  end

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  end
end
