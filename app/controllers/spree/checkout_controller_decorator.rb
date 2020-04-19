module SpreeWholesale
  module Spree
    module CheckoutControllerDecorator
      before_action :get_addresses
      before_action :create_a_password
      before_action :register_as_wholesaler

      def get_addresses
        return unless spree_current_user && spree_current_user.wholesaler? && !spree_current_user.wholesaler.nil?
        if spree_current_user.wholesaler.bill_address.present?
          @order.bill_address = spree_current_user.wholesaler.bill_address
          @order.ship_address = spree_current_user.wholesaler.ship_address
        end
      end

      def create_a_password
        return unless spree_current_user && spree_current_user.encrypted_password.nil?
        store_location
        redirect_to spree.edit_account_path
      end

      def register_as_wholesaler
        return unless spree_current_user && spree_current_user.lead?
        store_location
        redirect_to new_wholesaler_path
      end

    end
  end
end

::Spree::CheckoutController.prepend(SpreeWholesale::Spree::CheckoutControllerDecorator)
