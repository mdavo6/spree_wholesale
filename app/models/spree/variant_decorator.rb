Spree::PermittedAttributes.variant_attributes << :wholesale_price

Spree::Variant.class_eval do

  scope :wholesales, -> (currency) do
    currency ||= Spree::Config[:currency]
    joins(:prices).where("spree_prices.currency = ?", currency).where("spree_prices.wholesale = ?", true).where("spree_prices.amount > ?", 0)
  end

  def is_wholesaleable?
    prices.exists?(currency: currency, wholesale: true)
  end

  def wholesale_price
    prices.find_by(currency: currency, wholesale: true)
  end

  def price_in(currency, wholesale = false)
    prices.detect { |price| price.currency == currency && price.wholesale == wholesale } || prices.build(currency: currency, wholesale: wholesale)
  end

end
