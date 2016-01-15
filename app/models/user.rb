class User < ActiveRecord::Base
  has_many :wikis, through: :collaborators
  has_many :collaborators, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:standard, :premium, :admin]

  # before_save { self.username = email.downcase }

  def collaborator_for(wiki)
    collaborators.where(wiki_id: wiki.id).first
  end

end
