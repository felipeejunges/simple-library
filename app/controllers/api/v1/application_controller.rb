class Api::V1::ApplicationController < ApplicationController
  before_action :set_default_response_format
  skip_before_action :verify_authenticity_token

  private

  def not_authenticated
    render json: { error: 'Not authenticated' }
  end

  def set_default_response_format
    request.format = :json
  end
end
