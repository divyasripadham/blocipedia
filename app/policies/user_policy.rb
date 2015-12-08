class UserPolicy < ApplicationPolicy
  def user_downgrade?
    user.premium?
  end
end
