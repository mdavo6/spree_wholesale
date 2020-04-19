module SpreeWholesale
  module Spree
    module Admin
      module PricesControllerDecorator

        def create
          params.require(:vp).permit!
          params[:vp].each do |variant_id, prices|
            variant = Spree::Variant.find(variant_id)
            next unless variant
            supported_currencies.each do |currency|
              # Save retail price
              price = variant.price_in(currency.iso_code, false)
              price.price = (prices[currency.iso_code][:false].blank? ? nil : prices[currency.iso_code][:false])
              price.save! if price.new_record? && price.price || !price.new_record? && price.changed?

              # Save wholesale price
              price = variant.price_in(currency.iso_code, true)
              price.price = (prices[currency.iso_code][:true].blank? ? nil : prices[currency.iso_code][:true])
              price.save! if price.new_record? && price.price || !price.new_record? && price.changed?
            end
          end
          flash[:success] = Spree.t('notice_messages.prices_saved')
          redirect_to admin_product_path(parent)

        end
      end
    end
  end
end

::Spree::Admin::PricesController.prepend(SpreeWholesale::Spree::Admin::PricesControllerDecorator)
