module SpreeWholesale
  module Spree
    module OrderDecorator

      def self.prepended(base)
        base.scope :wholesale, -> { where(wholesale: true) }
        base.scope :retail, -> { where.not(wholesale: true) }
        base.whitelisted_ransackable_attributes << 'wholesale'
      end

      def payment_required?
        if (paid_with_paypal_express? || payment_via_transferwise? || wholesaler_has_net30_terms? || wholesale_payment_via_eft? || payment_via_paypal_invoice?)
          return false
        else
          return true
        end
      end

      def is_wholesale?
        wholesale || wholesale_store?
      end

      def wholesale_store?
        if store
          store.code.include?("wholesale")
        else
          current_store.code.include?("wholesale")
        end
      end

      def wholesale
        read_attribute(:wholesale) && !wholesaler.nil?
      end

      def wholesaler
        user && user.wholesaler
      end

      def is_lead?
        lead
      end

      def lead
        user && user.lead?
      end

      def is_wholesale_or_lead?
        is_wholesale? || is_lead?
      end

      def set_line_item_prices(use_price=:price)
        line_items.includes(:variant).each do |line_item|
          line_item.price = line_item.variant.send(use_price)
          line_item.save
        end
      end

      def to_fullsale!
        self.wholesale = false
        set_line_item_prices(:price)
        update_with_updater!
        save
      end

      def to_wholesale!
        return false unless user && user.wholesaler.present?
        self.wholesale = true
        set_line_item_prices(:wholesale_price)
        update_with_updater!
        save
      end

      # Associates the specified user with the order.
      def associate_user!(user, override_email = true)
        self.user           = user
        self.email          = user.email if override_email
        self.created_by   ||= user
        self.bill_address ||= user.bill_address
        self.ship_address ||= user.ship_address

        # Added line to indicate order is wholesale order if user has wholesale role
        self.wholesale = user.wholesaler?

        # Added wholesale to slice to ensure change above is saved
        changes = slice(:user_id, :email, :created_by_id, :bill_address_id, :ship_address_id, :wholesale)

        # immediately persist the changes we just made, but don't use save
        # since we might have an invalid address associated
        self.class.unscoped.where(id: self).update_all(changes)
      end

      def wholesale_order_and_user?
        self.is_wholesale? && wholesaler.present?
      end

      def wholesaler_has_net30_terms?
        wholesale_order_and_user? && (wholesaler.terms == 'Net30' || wholesaler.terms == 'Transferwise USD Net30')
      end

      def wholesaler_is_net30_or_paypal?
        wholesale_order_and_user? && (wholesaler.terms == 'Net30' || wholesaler.terms == 'Transferwise USD Net30' || wholesaler.terms == 'Paypal Invoice')
      end

      def payment_via_eft_net30?
        wholesale_order_and_user? && wholesaler.terms == 'Net30'
      end

      def payment_via_transferwise?
        wholesale_order_and_user? && (wholesaler.terms == 'Transferwise USD' || wholesaler.terms == 'Transferwise EUR')
      end

      def payment_via_transferwise_eur?
        wholesale_order_and_user? && wholesalerwholesaler.terms == 'Transferwise EUR'
      end

      def payment_via_transferwise_usd?
        wholesale_order_and_user? && (wholesaler.terms == 'Transferwise USD' || wholesaler.terms == 'Transferwise USD Net30')
      end

      def payment_via_transferwise_usd_net30?
        wholesale_order_and_user? && wholesaler.terms == 'Transferwise USD Net30'
      end

      def wholesale_payment_via_eft?
        wholesale_order_and_user? && wholesaler.terms == 'EFT'
      end

      def payment_via_paypal_invoice?
        wholesale_order_and_user? && wholesaler.terms == 'Paypal Invoice'
      end

      private

      def wholesaler_with_payment_in_advance?
        self.is_wholesale? && wholesaler.terms == 'Advance'
      end
    end
  end
end

::Spree::Order.prepend(SpreeWholesale::Spree::OrderDecorator) if ::Spree::Order.included_modules.exclude?(SpreeWholesale::Spree::OrderDecorator)
