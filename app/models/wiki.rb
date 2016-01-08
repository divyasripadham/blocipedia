class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborators
  has_many :collaborators, dependent: :destroy
  validates :user, presence: true

  default_scope { order('updated_at DESC') }
  # scope :visible_to, -> (user) { (user.admin?) ? all : ((user.premium?) ? (where("user_id = ? OR private = ?",user.id,false)) : where(private: false)) }
end
