Spree::PermittedAttributes.product_attributes << :wholesale_price

# Spree::Product.instance_eval do
#   delegate_belongs_to :master, :wholesale_price if Spree::Variant.table_exists? && Spree::Variant.column_names.include?("wholesale_price")
# end

module SpreeWholesale
  module Spree
    module ProductDecorator

      def is_wholesaleable?
        master.prices.exists?(currency: currency, wholesale: true)
      end

      def wholesale_price
        master.prices.find_by(currency: currency, wholesale: true)
      end

      def self.wholesaleable
        wholesale_products = []
        all.each do |p|
          wholesale_products << p if p.is_wholesaleable?
        end
        wholesale_products
      end

    end
  end
end

::Spree::Product.prepend(SpreeWholesale::Spree::ProductDecorator)
