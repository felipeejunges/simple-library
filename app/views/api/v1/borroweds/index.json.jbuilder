# frozen_string_literal: true

json.array! @borroweds, partial: 'api/v1/borroweds/borrowed', as: :borrowed
