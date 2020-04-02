class Spree::WholesalersController < Spree::StoreController
  before_action :new_subscriber
  respond_to :html, :xml
  before_action :check_wholesale_user, :except => [:new, :index, :registration, :update_registration]
  after_action :persist_user_address, :only => [:create, :update]

  def new
    @wholesaler = Spree::Wholesaler.new
    @wholesaler.user = spree_current_user
    @wholesaler.bill_address = Spree::Address.default
    @wholesaler.ship_address = Spree::Address.default
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
        flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
        Spree::WholesaleMailer.new_wholesaler_email(@wholesaler).deliver
        # To be discussed - Could give wholesalers access to wholesale prices immediately?
        # @wholesaler.activate!
        redirect_to spree.account_path
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

  # Checks whether the user signed up via the wholesale page (wholesale_user)
  # A wholesale_user is not the same as a wholesaler - The wholesale_user flag
  # is used to identify that the user signed up via the wholesalers page, whereas
  # a wholesaler has been approved.

  def check_wholesale_user
    # Always want registration so comment out config
    # return unless Spree::Auth::Config[:registration_step]
    if spree_current_user
      return if spree_current_user.admin? || spree_current_user.wholesale_user || spree_current_user.wholesaler_or_lead?
      flash[:notice] = I18n.t('spree.wholesaler.not_a_wholesaler')
      redirect_to spree.signup_path(wholesale_user: true)
    else
      flash[:notice] = I18n.t('spree.wholesaler.logged_out')
      redirect_to spree.signup_path(wholesale_user: true)
    end
  end

  def persist_user_address
    if spree_current_user
      spree_current_user.bill_address_id = @wholesaler.billing_address_id
      spree_current_user.ship_address_id = @wholesaler.shipping_address_id
      spree_current_user.save
    end
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
