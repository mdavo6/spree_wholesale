module SpreeWholesale
  module Spree
    module AddressDecorator
      def require_phone?
        false
      end
    end
  end
end

::Spree::AddressDecorator.prepend(SpreeWholesale::Spree::AddressDecorator)
