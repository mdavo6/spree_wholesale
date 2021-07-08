module Spree
  module VariantPresenterDecorator

    def self.prepended(base)
      base.include Spree::PriceHelper
    end

  end
end

::Spree::VariantPresenter.prepend(Spree::VariantPresenterDecorator)
