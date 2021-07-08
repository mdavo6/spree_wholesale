module Spree
  module StoreControllerDecorator

    # Checks whether the user signed up via the wholesale page (wholesale_user)
    # A wholesale_user is not the same as a wholesaler - The wholesale_user flag
    # is used to identify that the user signed up via the wholesalers page, whereas
    # a wholesaler has been approved.

    def wholesale_store?
      current_store.code.include?("wholesale")
    end

    def is_home?
      request.path == "/"
    end

    def is_new_wholesale_address?
      request.path == "/addresses/new_wholesale"
    end

    def check_wholesale_authorisation
      if spree_current_user
        return if spree_current_user.permitted_wholesale_user?
        redirect_to spree.account_path
      else
        flash[:notice] = I18n.t('spree.wholesaler.logged_out')
        redirect_to spree.login_path
      end
    end

  end
end

::Spree::StoreController.prepend(Spree::StoreControllerDecorator)
