# frozen_string_literal: true

json.partial! 'api/v1/shared/pagination'

json.data do
  json.array! @users, partial: 'api/v1/users/user', as: :user
end
