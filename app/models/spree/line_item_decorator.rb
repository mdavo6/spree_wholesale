module SpreeWholesale
  module LineItemDecorator
    def copy_price
      if variant
        self.price = (order.is_wholesale? && variant.is_wholesaleable? ? variant.wholesale_price : variant.price)
        self.cost_price = variant.cost_price if cost_price.nil?
        self.currency = variant.currency if currency.nil?
      end
    end
  end
end

Spree::LineItem.class_eval do
  prepend SpreeWholesale::LineItemDecorator

  delegate_belongs_to :variant, :wholesale_price
  delegate_belongs_to :variant, :is_wholesaleable?
end
