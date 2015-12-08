class ChargesController < ApplicationController

  before_action :authenticate_user!

  def new
    authorize :charge
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.username}",
      amount: Amount.default
    }
  end

  def create
    authorize :charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: Amount.default,
      description: "BigMoney Membership - #{current_user.email}",
      currency: 'usd'
    )

    if current_user.premium!
       flash[:notice] = "You have been upgraded to Premium"
    else
       flash[:error] = "There was an error upgrading the user. Please contact Support."
    end

    redirect_to edit_user_registration_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end

  # def destroy
  #   # current_user.update_attribute(:role, 0)
  #   if current_user.standard!
  #      flash[:notice] = "You have been downgraded to Standard"
  #   else
  #      flash[:error] = "There was an error downgrading the user. Please contact Support."
  #   end
  #   redirect_to edit_user_registration_path
  # end

end
