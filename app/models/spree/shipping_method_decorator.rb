Spree::ShippingMethod.class_eval do

  # Applies only wholesale shipping methods if wholesale order
  def valid_for_order_type(wholesale)
    if wholesale
      self.wholesale
    else
      !self.wholesale
    end
  end

end
