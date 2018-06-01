class Spree::WholesalersController < Spree::StoreController
  respond_to :html, :xml
  before_filter :check_wholesale_user, :except => [:index, :registration, :update_registration]

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
    @wholesaler.user = spree_current_user
    if @wholesaler.save
      flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
      Spree::WholesaleMailer.new_wholesaler_email(@wholesaler).deliver
      # To be discussed - Could give wholesalers access to wholesale prices immediately?
      # @wholesaler.activate!
      redirect_to spree.account_path
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
      @wholesaler.user = spree_current_user
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

  # Checks whether the user signed up via the wholesale page (wholesale_user)
  # A wholesale_user is not the same as a wholesaler - The wholesale_user flag
  # is used to identify that the user signed up via the wholesalers page, whereas
  # a wholesaler has been approved.

  def check_wholesale_user
    # Always want registration so comment out config
    # return unless Spree::Auth::Config[:registration_step]
    if spree_current_user
      return if spree_current_user.admin? || spree_current_user.wholesale_user
      flash[:notice] = I18n.t('spree.wholesaler.not_a_wholesaler')
      redirect_to spree.signup_path(wholesale_user: true)
    else
      flash[:notice] = I18n.t('spree.wholesaler.logged_out')
      redirect_to spree.signup_path(wholesale_user: true)
    end
  end

  # Checks whether the user has entered their company details and redirects
  # to the new wholesaler path
  # def company_information_entered
  #   return if spree_current_user.wholesaler?
  #   if spree_current_user.wholesaler.nil?
  #     flash[:notice] = I18n.t('spree.wholesaler.more_information_required')
  #     redirect_to spree.new_wholesaler_path
  #   else
  #     flash[:notice] = I18n.t('spree.wholesaler.review_in_progress')
  #     redirect_to spree.wholesalers_path
  #   end
  # end

  private

  def permitted_address_attributes
    [:firstname, :lastname, :address1, :address2, :city, :state_id, :zipcode, :country_id, :phone, :id]
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
