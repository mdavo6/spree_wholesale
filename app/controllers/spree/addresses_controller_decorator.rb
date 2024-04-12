module Spree
  module AddressesControllerDecorator

    def new_wholesale
      user = Spree::User.find_by(email: params[:email])
      @address = Spree::Address.new(country: current_store.default_country, user: user)
    end

    def create
      @address = try_spree_current_user.addresses.build(address_params)
      if @address.save
        if wholesale_store? && !try_spree_current_user.wholesaler?
          flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
          Spree::WholesaleMailer.new_wholesaler_email(try_spree_current_user).deliver
          Spree::WholesaleMailer.new_signup_notification(try_spree_current_user).deliver
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

    def update
      if update_service.call(address: @address, address_params: address_params).success?
        flash[:notice] = Spree.t(:successfully_updated, scope: :address_book)
        redirect_to spree.account_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

  end
end

::Spree::AddressesController.prepend(Spree::AddressesControllerDecorator)
