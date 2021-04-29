module Spree
  module AddressDecorator
    def require_phone?
      false
    end
  end
end

::Spree::Address.prepend(Spree::AddressDecorator)
