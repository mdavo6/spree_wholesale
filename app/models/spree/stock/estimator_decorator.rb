Spree::Stock::Estimator.class_eval do

  def shipping_methods(package, display_filter)
    package.shipping_methods.select do |ship_method|
      calculator = ship_method.calculator

      # Added extra condition to check if wholesale order as
      # different shipping options may apply
      ship_method.available_to_display(display_filter) &&
      ship_method.include?(order.ship_address) &&
      ship_method.valid_for_order_type(order.wholesale) &&
      calculator.available?(package) &&
      (calculator.preferences[:currency].blank? ||
       calculator.preferences[:currency] == currency)
    end
  end

end
