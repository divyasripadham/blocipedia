module UsersHelper
  def user_has_premium_role?
    user.premium?
  end
end
