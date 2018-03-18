class Spree::WholesalersController < Spree::StoreController
  respond_to :html, :xml
  before_filter :check_registration, :except => [:registration, :update_registration]
  before_filter :check_details_entered, :except => [:registration, :update_registration]

  def registration
    @user = Spree::User.new
  end

  def update_registration
    if params[:wholesaler][:email] =~ Devise.email_regexp && current_order.update_attribute(:email, params[:wholesaler][:email])
      redirect_to spree.checkout_path
    else
      flash[:registration_error] = t(:email_is_invalid, :scope => [:errors, :messages])
      @user = Spree::Wholesaler.new
      render 'registration'
    end
  end

  # Commented out as SSL is required site-wide
  #ssl_required :new, :create

  def new
    @wholesaler = Spree::Wholesaler.new
    @wholesaler.user = spree_current_user
    @wholesaler.bill_address = Spree::Address.default
    @wholesaler.ship_address = Spree::Address.default
    respond_with(@wholesaler)
  end

  def index
  end

  def show
    @wholesaler = Spree::Wholesaler.find(params[:id])
    respond_with(@wholesaler)
  end

  def create
    @wholesaler = Spree::Wholesaler.new(wholesaler_params)
    if @wholesaler.save
      flash[:notice] = I18n.t('spree.wholesaler.signup_success')
      #WholesaleMailer.new_wholesaler_email(@wholesaler).deliver
      redirect_to spree.wholesalers_path
    else
      flash[:error] = I18n.t('spree.wholesaler.signup_failed')
      render :action => "new"
    end
  end

  def edit
    @wholesaler = Spree::Wholesaler.find(params[:id])
    respond_with(@wholesaler)
  end

  def update
    @wholesaler = Spree::Wholesaler.find(params[:id])

    if @wholesaler.update_attributes(wholesaler_params)
      flash[:notice] = I18n.t('spree.wholesaler.update_success')
    else
      flash[:error] = I18n.t('spree.wholesaler.update_failed')
    end
    respond_with(@wholesaler)
  end

  def destroy
    @wholesaler = Spree::Wholesaler.find(params[:id])
    @wholesaler.destroy
    flash[:notice] = I18n.t('spree.wholesaler.destroy_success')
    respond_with(@wholesaler)
  end

  # Introduces a registration step.
  def check_registration
    # Always want registration so comment out config
    #return unless Spree::Auth::Config[:registration_step]

    # Wholesale request is a bolean which indicates if the username and password
    # were entered via the wholesaler registration form
    return if spree_current_user && (spree_current_user.wholesaler? || spree_current_user.wholesale_request)
    store_location
    redirect_to spree.wholesaler_registration_path
  end

  # Introduces a registration step.
  def check_details_entered
    # Always want registration so comment out config
    #return unless Spree::Auth::Config[:registration_step]
    user_id = spree_current_user.id
    return if Spree::Wholesaler.find_by_user_id(user_id).present?
    redirect_to spree.new_wholesaler
  end

  private

  def permitted_address_attributes
    [:firstname, :lastname, :address1, :address2, :city, :state_id, :zipcode, :country_id, :phone]
  end

  def wholesaler_params
    params.require(:wholesaler).
      permit(:ship_address, :bill_address, :company, :contact_person,
        :phone, :web_address, :social_media, :comments, :use_billing,
        user_attributes: [:email, :password, :password_confirmation],
        bill_address_attributes: permitted_address_attributes,
        ship_address_attributes: permitted_address_attributes)
  end
end
