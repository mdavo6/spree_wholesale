module SpreeWholesale
  module Spree
    module Admin
      module OrdersControllerDecorator

        def currency
          @currency = supported_currencies.find { |currency| currency.iso_code == params[:currency] }
          # Make sure that we update the current order, so the currency change is reflected.
          @order = Spree::Order.includes(:adjustments).friendly.find(params[:id])
          @order.update_attributes!(currency: @currency.iso_code) if @order
          session[:currency] = params[:currency] if Spree::Config[:allow_currency_change]
          respond_to do |format|
            format.json { render json: !@currency.nil? }
            format.html do
              # We want to go back to where we came from!
              redirect_back_or_default(root_path)
            end
          end
        end
      end
    end
  end
end

::Spree::Admin::OrdersController.prepend(SpreeWholesale::Spree::Admin::OrdersControllerDecorator)
