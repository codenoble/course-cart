class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    # This is a temporary workaround for namespaces an seen here: https://github.com/elabs/pundit/issues/351
    @record = record.is_a?(Array) ? record.last : record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      # This is a temporary workaround for namespaces an seen here: https://github.com/elabs/pundit/issues/351
      @scope = scope.is_a?(Array) ? scope.last : scope
    end

    def resolve
      scope.all
    end
  end
end
