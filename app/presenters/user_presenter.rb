# frozen_string_literal: true

class UserPresenter < SimpleDelegator
  def self.user_options
    User.all.map do |user|
      [user.name, user.id]
    end
  end
end
