class WikiPolicy < ApplicationPolicy
  def create?
    user.standard?
  end
end
