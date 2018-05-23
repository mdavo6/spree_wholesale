Spree::PermittedAttributes.variant_attributes << :wholesale_price

Spree::Variant.class_eval do
  scope :wholesales, ->{where("spree_variants.wholesale_price > 0")}

  def is_wholesaleable?
    prices.exists?(currency: currency, wholesale: true)
  end

  def price_in(currency, wholesale = false)
    prices.detect { |price| price.currency == currency && price.wholesale == wholesale } || prices.build(currency: currency, wholesale: wholesale)
  end

end
