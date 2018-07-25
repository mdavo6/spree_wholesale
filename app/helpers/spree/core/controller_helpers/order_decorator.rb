Spree::Core::ControllerHelpers::Order.module_eval  do

  # The current incomplete order from the guest_token for use in cart and during checkout
  def current_order(options = {})
    options[:create_order_if_necessary] ||= false

    return @current_order if @current_order

    @current_order = find_order_by_token_or_user(options, true)

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = Spree::Order.new(current_order_params)
      @current_order.user ||= try_spree_current_user

      # This line added to see the current order as a wholesale order
      @current_order.wholesale = spree_current_user.wholesaler? if spree_current_user

      # If statement added to ensure affiliate or referral code is applied at cart - From Spree_Reffiliate
      if session[:affiliate]
        @current_order.affiliate = Spree::Affiliate.find_by(path: cookies[:affiliate])
      elsif session[:referral]
        @current_order.referral = Spree::Referral.find_by(code: cookies[:referral])
      end

      # See issue #3346 for reasons why this line is here
      @current_order.created_by ||= try_spree_current_user
      @current_order.save!
    end

    if @current_order
      if spree_current_user
        if spree_current_user.wholesaler? && !@current_order.is_wholesale?
          @current_order.to_wholesale!
        elsif !spree_current_user.wholesaler? && @current_order.is_wholesale?
          @current_order.to_fullsale!
        end
      end
      @current_order.last_ip_address = ip_address
      return @current_order
    end
  end

end
