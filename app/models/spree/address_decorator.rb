module Spree
  module AddressDecorator
    def require_phone?
      false
    end
    
    def self.prepended(base)
      base.scope :store_address, -> { where(store: true) }
      base.scope :on_stockist_list, -> { where(stockist_list: true) }
    end
  end
end

::Spree::Address.prepend(Spree::AddressDecorator)
