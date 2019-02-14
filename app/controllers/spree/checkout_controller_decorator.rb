Spree::CheckoutController.class_eval do
  before_filter :get_addresses

  def get_addresses
    return unless spree_current_user && spree_current_user.wholesaler? && !spree_current_user.wholesaler.nil?
    if spree_current_user.bill_address.nil?
      @order.bill_address = spree_current_user.wholesaler.bill_address
      @order.ship_address = spree_current_user.wholesaler.ship_address
    end
  end

end
