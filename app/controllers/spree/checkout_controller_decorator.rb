Spree::CheckoutController.class_eval do
  before_filter :get_addresses
  before_filter :remove_zero_line_items

  def get_addresses
    return unless spree_current_user && spree_current_user.wholesaler? && !spree_current_user.wholesaler.nil?
    if spree_current_user.bill_address.nil?
      @order.bill_address = spree_current_user.wholesaler.bill_address
      @order.ship_address = spree_current_user.wholesaler.ship_address
    end
  end

  # Removes zero quantity items from order once order reaches confirm step
  def remove_zero_line_items
    if @order.is_wholesale? && @order.state == "confirm"
      @order.line_items = @order.line_items.select { |li| li.quantity > 0 }
    end
  end
end
