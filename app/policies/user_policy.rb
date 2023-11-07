# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    user.librarian? || user == record
  end

  def destroy?
    user.librarian? && user != record
  end
end