Spree::OrdersController.class_eval do

  def wholesale

    order    = current_order(create_order_if_necessary: true)
    in_stock_wholesale_variants  = Spree::Variant.in_stock.wholesales(current_currency)
    quantity = 0
    options  = params[:options] || {}
    #
    # # 2,147,483,647 is crazy. See issue #2695.
    #
    WholesaleJob.new.perform(order, quantity, in_stock_wholesale_variants, options)
    # in_stock_wholesale_variants.each do |variant|
    #
    #   begin
    #     order.contents.add(variant, quantity, options)
    #   rescue ActiveRecord::RecordInvalid => e
    #     error = e.record.errors.full_messages.join(", ")
    #   end
    #
    #   if error
    #     flash[:error] = error
    #     redirect_back_or_default(spree.root_path)
    #   end
    #
    # end

    respond_with(order) do |format|
      format.html { redirect_to cart_path }
    end

  end

end
