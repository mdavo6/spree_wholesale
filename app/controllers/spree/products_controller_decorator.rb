module Spree
  module ProductsControllerDecorator

    def self.prepended(base)
      base.before_action :check_wholesale_authorisation, if: :wholesale_store?
      base.include Spree::PriceHelper
    end

  end
end

::Spree::ProductsController.prepend(Spree::ProductsControllerDecorator)
