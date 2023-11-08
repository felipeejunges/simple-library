# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  def search?
    index?
  end

  def borrow?
    index?
  end
end
