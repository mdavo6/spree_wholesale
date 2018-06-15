Spree::Shipment.class_eval do

  # Determines the appropriate +state+ according to the following logic:
  #
  # pending    unless order is complete and +order.payment_state+ is +paid+
  # shipped    if already shipped (ie. does not change the state)
  # ready      all other cases
  def determine_state(order)
    return 'canceled' if order.canceled?
    return 'pending' unless order.can_ship?
    return 'pending' if inventory_units.any? &:backordered?
    return 'shipped' if shipped?

    # Added wholesaler has net terms to allow order to be shipped prior to payment being received.
    order.paid? || Spree::Config[:auto_capture_on_dispatch] || order.wholesaler_has_net30_terms ? 'ready' : 'pending'
  end

end
