module Spree
  module AddressesControllerDecorator

    def new_wholesale
      @address = Spree::Address.default
    end

    def create
      @address = try_spree_current_user.addresses.build(address_params)
      if @address.save
        if wholesale_store? && !try_spree_current_user.wholesaler?
          flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
          Spree::WholesaleMailer.new_wholesaler_email(@wholesaler).deliver
        else
          flash[:notice] = I18n.t(:successfully_created, scope: :address_book)
        end
        redirect_to spree.account_path
      else
        if try_spree_current_user.wholesaler?
          render action: 'new'
        else
          render action: 'new_wholesaler'
        end
      end
    end

  end
end

::Spree::AddressesController.prepend(Spree::AddressesControllerDecorator)
