class Collaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :wiki

  def username
    if user.present?
      user.username
    end
  end
end
