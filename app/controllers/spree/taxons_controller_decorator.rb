module Spree
  module TaxonsControllerDecorator

    def self.prepended(base)
      base.before_action :check_wholesale_authorisation, if: :wholesale_store?
    end

  end
end

::Spree::TaxonsController.prepend(Spree::TaxonsControllerDecorator)
