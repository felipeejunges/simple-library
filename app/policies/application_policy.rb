# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user.librarian?
  end

  def list?
    index?
  end

  def show?
    index?
  end

  def create?
    user.librarian?
  end

  def new?
    create?
  end

  def update?
    user.librarian?
  end

  def edit?
    update?
  end

  def destroy?
    user.librarian?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
