module Spree
  module Order
    module CurrencyUpdaterDecorator

      # Returns the price object from given item
      def price_from_line_item(line_item)
        if line_item.order.wholesale && line_item.variant.is_wholesaleable?
          line_item.variant.prices.where(currency: currency, wholesale: true).first
        else
          line_item.variant.prices.where(currency: currency, wholesale: false).first
        end
      end

    end
  end
end

::Spree::Order.prepend(Spree::Order::CurrencyUpdaterDecorator)
