class UsersController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = current_user
  end
  
  def user_downgrade
    authorize :user
    # current_user.update_attribute(:role, 0)
    if current_user.standard!
       flash[:notice] = "You have been downgraded to Standard"
    else
       flash[:error] = "There was an error downgrading the user. Please try again."
    end
    redirect_to edit_user_registration_path
  end
end
