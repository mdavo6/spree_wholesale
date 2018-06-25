Spree::Stock::ContentItem.class_eval do

  with_options allow_nil: true do
  delegate :line_item,
           :variant, to: :inventory_unit
  delegate :price,
           :price_in, to: :variant
  delegate :dimension,
           :volume,
           :weight, to: :variant, prefix: true
  end

  def amount
    price_in(line_item.currency, false).amount * quantity
  end

end
