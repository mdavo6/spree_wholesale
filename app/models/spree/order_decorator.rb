Spree::Order.class_eval do

  # Added to allow admin search for wholesale orders
  self.whitelisted_ransackable_attributes =  %w[completed_at created_at email number state payment_state shipment_state total considered_risky wholesale]

  def payment_required?

    # Added for Spree Braintree vZero
    return false if paid_with_paypal_express?

    return true unless payment_via_transferwise || wholesaler_has_net30_terms || payment_via_eft

  end

  def is_wholesale?
    wholesale
  end

  def wholesale
    read_attribute(:wholesale) && !wholesaler.nil?
  end

  def wholesaler
    user && user.wholesaler
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
    update!
    save
  end

  def to_wholesale!
    return false unless user && user.wholesaler.present?
    self.wholesale = true
    set_line_item_prices(:wholesale_price)
    update!
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

  def wholesaler_has_net30_terms
    self.is_wholesale? && wholesaler.terms == 'Net30'
  end

  private

  def payment_via_transferwise
    self.is_wholesale? && (wholesaler.terms == 'Transferwise USD' || wholesaler.terms == 'Transferwise EUR')
  end

  def wholesaler_with_payment_in_advance?
    self.is_wholesale? && wholesaler.terms == 'Advance'
  end

  def payment_via_eft
    self.is_wholesale? && wholesaler.terms == 'EFT'
  end

end
