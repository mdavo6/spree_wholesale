module Spree
  module UsersControllerDecorator

    def update
      if @user.update_attributes(user_params)
        if params[:user][:password].present?
          # this logic needed b/c devise wants to log us out after password changes
          user = Spree::User.reset_password_by_token(params[:user])
          sign_in(@user, :event => :authentication, :bypass => !Spree::Auth::Config[:signout_after_password_change])
        end
        if @user.lead? && current_order
          redirect_to checkout_state_path(current_order.state), :notice => Spree.t(:password_set)
        else
          redirect_to spree.account_url, :notice => Spree.t(:account_updated)
        end
      else
        render :edit
      end
    end

  end
end

::Spree::UsersController.prepend(Spree::UsersControllerDecorator)
