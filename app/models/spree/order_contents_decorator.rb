module SpreeWholesale
  module Spree
    module OrderContentsDecorator

      def add_to_line_item(variant, quantity, options = {})
        line_item = grab_line_item_by_variant(variant, false, options)

        if line_item
          line_item.quantity += quantity.to_i
          line_item.currency = currency unless currency.nil?
        else
          # Added wholesale option
          opts = { currency: order.currency, wholesale: (order.is_wholesale_or_lead? && variant.is_wholesaleable?) }.
                                              merge ActionController::Parameters.new(options).
                                              permit(Spree::PermittedAttributes.line_item_attributes)
          line_item = order.line_items.new(quantity: quantity,
                                            variant: variant,
                                            options: opts)
        end
        line_item.target_shipment = options[:shipment] if options.has_key? :shipment
        line_item.save!
        line_item
      end

    end
  end
end

::Spree::OrderContents.prepend(SpreeWholesale::Spree::OrderContentsDecorator)
