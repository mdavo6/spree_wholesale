module Spree
  module PriceHelper
    def display_wholesale_price(product_or_variant, wholesale = false)
      product_or_variant.
        price_in(current_currency, wholesale).
        display_price_including_vat_for(current_price_options).
        to_html
    end

    def schema_wholesale_price(product_or_variant)
      product_or_variant.price_in(current_currency, true).
      amount.to_s
    end
  end
end
