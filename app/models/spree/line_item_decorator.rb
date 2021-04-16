Spree::LineItem.class_eval do
  delegate :wholesale_price, to: :variant
  delegate :is_wholesaleable?, to: :variant

  def update_price
    currency_price = Spree::Price.where(
      currency: order.currency,
      variant_id: variant_id,
      wholesale: (order.is_wholesale? && variant.is_wholesaleable?)
    ).first

    self.price = currency_price.price_including_vat_for(tax_zone: tax_zone)
  end

  def options=(options = {})
    return unless options.present?
    opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

    currency = opts.delete(:currency) || order.try(:currency)
    wholesale = opts.delete(:wholesale)

    update_price_from_modifier(currency, wholesale, opts)
    assign_attributes opts
  end

  def update_price_from_modifier(currency, wholesale, opts)
    if currency
      self.currency = currency
      if wholesale
        self.price = variant.price_in(currency, wholesale).amount +
          variant.price_modifier_amount_in(currency, opts)
      else
        self.price = variant.price_in(currency).amount +
          variant.price_modifier_amount_in(currency, opts)
      end
    else
      self.price = variant.price +
        variant.price_modifier_amount(opts)
    end
  end

end
