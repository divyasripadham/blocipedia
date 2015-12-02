class Wiki < ActiveRecord::Base
  belongs_to :user
  default_scope { order('updated_at DESC') }
  validates :user, presence: true
  scope :visible_to, -> (user) { user ? all : where(private: false) }
end
