class ChargePolicy < ApplicationPolicy
  def create?
    user.standard?
  end
  def new?
    create?
  end
end
