class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :users, through: :collaborators
  has_many :collaborators, dependent: :destroy
  validates :user, presence: true

  default_scope { order('private DESC') }
  # scope :visible_to, -> (user) { (user.admin?) ? all : ((user.premium?) ? (where("user_id = ? OR private = ?",user.id,false)) : where(private: false)) }

  def list_of_users
    if collaborators.nil?
      User.all
    else
      User.where.not(id: collaborators.map(&:user_id))
    end
  end

end
