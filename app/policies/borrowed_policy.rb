# frozen_string_literal: true

class BorrowedPolicy < ApplicationPolicy
  def return_book
    updated?
  end
end
