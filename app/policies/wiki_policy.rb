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
        scope.eager_load(:collaborators).where("collaborators.user_id = ? OR wikis.user_id = ? OR wikis.private = ?",user.id,user.id,false)
      else
        scope.eager_load(:collaborators).where("collaborators.user_id = ? OR wikis.private = ?",user.id,false)
      end
    end
  end

  def destroy?
    user.admin?
  end
end
