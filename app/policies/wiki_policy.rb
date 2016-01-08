class WikiPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.where(private: false) unless user.present?

      if user.admin?
        scope.all
      elsif user.premium?
        scope.where("user_id = ? OR private = ?",user.id,false)
      else
        scope.where(private: false)
      end
    end
  end

  def destroy?
    user.admin?
  end
end
