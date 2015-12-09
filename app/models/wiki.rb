class Wiki < ActiveRecord::Base
  belongs_to :user
  default_scope { order('updated_at DESC') }
  validates :user, presence: true
  scope :visible_to, -> (user) { (user.admin?) ? all : ((user.premium?) ? (where("user_id = ? OR private = ?",user.id,false)) : where(private: false)) }
end
