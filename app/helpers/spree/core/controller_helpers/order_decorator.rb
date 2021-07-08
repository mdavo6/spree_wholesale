module Spree
  module Core
    module ControllerHelpers
      module OrderDecorator

        # The current incomplete order from the guest_token for use in cart and during checkout
        def current_order(options = {})
          options[:create_order_if_necessary] ||= false
          options[:includes] ||= true

          if @current_order
            @current_order.last_ip_address = ip_address
            return @current_order
          end

          @current_order = find_order_by_token_or_user(options, true)

          if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
            @current_order = Spree::Order.create!(current_order_params)
            @current_order.associate_user! try_spree_current_user if try_spree_current_user
            @current_order.last_ip_address = ip_address

            # This line added to see the current order as a wholesale order
            @current_order.wholesale = spree_current_user.wholesaler_or_lead? if spree_current_user

            # If statement added to ensure affiliate or referral code is applied at cart - From Spree_Reffiliate
            if cookies[:affiliate]
              @current_order.affiliate = Spree::Affiliate.find_by(path: cookies[:affiliate])
            elsif cookies[:referral]
              @current_order.referral = Spree::Referral.find_by(code: cookies[:referral])
            end
          end

          if @current_order && spree_current_user
            if spree_current_user.wholesaler_or_lead? && !@current_order.is_wholesale?
              @current_order.to_wholesale!
            elsif !spree_current_user.wholesaler_or_lead? && @current_order.is_wholesale?
              @current_order.to_fullsale!
            end
          end

          @current_order
        end

      end
    end
  end
end

::Spree::Core::ControllerHelpers::Order.prepend(Spree::Core::ControllerHelpers::OrderDecorator)
