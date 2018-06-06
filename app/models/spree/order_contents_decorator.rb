Spree::OrderContents.class_eval do

  def add_to_line_item(variant, quantity, options = {})
    line_item = grab_line_item_by_variant(variant, false, options)

    if line_item
      line_item.quantity += quantity.to_i
      line_item.currency = currency unless currency.nil?
    else
      opts = { currency: order.currency, wholesale: (order.is_wholesale? && variant.is_wholesaleable?) }.
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

  def update_cart(params)
    if order.update_attributes(filter_order_items(params))
      if order.is_wholesale?
        order.line_items = order.line_items.select { |li| li.quantity >= 0 }
      else
        order.line_items = order.line_items.select { |li| li.quantity > 0 }
      end
      # Update totals, then check if the order is eligible for any cart promotions.
      # If we do not update first, then the item total will be wrong and ItemTotal
      # promotion rules would not be triggered.
      persist_totals
      Spree::PromotionHandler::Cart.new(order).activate
      order.ensure_updated_shipments
      persist_totals
      true
    else
      false
    end
  end

end
