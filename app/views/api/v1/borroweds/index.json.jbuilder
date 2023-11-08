# frozen_string_literal: true

json.partial! 'api/v1/shared/pagination'

json.data do
  json.array! @borroweds, partial: 'api/v1/borroweds/borrowed', as: :borrowed
end
