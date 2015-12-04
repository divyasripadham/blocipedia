class WikiPolicy < ApplicationPolicy
  def destroy?
    user.admin?
  end
end
