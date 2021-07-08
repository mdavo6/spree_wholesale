module Spree
  class WholesalersController < Spree::StoreController
    respond_to :html, :xml

    def new
      @wholesaler = Spree::Wholesaler.new
      @wholesaler.user = spree_current_user
      respond_with(@wholesaler)
    end

    def index
      @wholesalers = Spree::Wholesaler.is_visible.has_visible_address
      @countries = {}
      @wholesalers.group_by { |w| w.visible_address.country.try(:name) }.each do |country, wholesalers|
        states = wholesalers.map { |w| w.visible_address.state.name }.uniq.to_a
        @countries[country] = states
      end
    end

    def show
      @wholesaler = Spree::Wholesaler.find(params[:id])
      respond_with(@wholesaler)
    end

    def create
      @wholesaler = Spree::Wholesaler.new(wholesaler_params)
      @wholesaler.user = spree_current_user
      if @wholesaler.save
        if @wholesaler.user.lead?
          @wholesaler.convert_lead_to_wholesaler!
          if current_order
            redirect_to checkout_state_path(current_order.state)
          else
            redirect_to spree.account_path
          end
        else
          # Add these notifications after address added
          # flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
          # Spree::WholesaleMailer.new_wholesaler_email(@wholesaler).deliver

          redirect_to spree.new_wholesale_address_path
        end
      else
        flash[:error] = I18n.t('spree.wholesaler.signup_failed')
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @wholesaler = Spree::Wholesaler.find(params[:id])
      respond_with(@wholesaler)
    end

    def update
      @wholesaler = Spree::Wholesaler.find(params[:id])

      if @wholesaler.update_attributes(wholesaler_params)
        @wholesaler.user = spree_current_user
        flash[:notice] = I18n.t('spree.wholesaler.update_success')
        redirect_to spree.account_path
      else
        render :edit
      end
    end

    def destroy
      @wholesaler = Spree::Wholesaler.find(params[:id])
      @wholesaler.destroy
      flash[:notice] = I18n.t('spree.wholesaler.destroy_success')
      respond_with(@wholesaler)
    end

    private

    def permitted_address_attributes
      [:firstname, :lastname, :company, :address1, :address2, :city, :state_id, :zipcode, :country_id, :phone, :id]
    end

    def wholesaler_params
      params.require(:wholesaler).
        permit(:ship_address, :bill_address, :company, :buyer,
          :terms, :phone, :website, :social, :comments, :use_billing,
          user_attributes: [:email, :password, :password_confirmation],
          bill_address_attributes: permitted_address_attributes,
          ship_address_attributes: permitted_address_attributes)
    end
  end
end
