class User < ActiveRecord::Base
  has_many :wikis
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:standard, :premium, :admin]
end
