Spree::OrdersController.class_eval do

  def wholesale

    order    = current_order(create_order_if_necessary: true)
    in_stock_wholesale_variants  = Spree::Variant.in_stock.wholesales(current_currency)
    quantity = 0
    options  = params[:options] || {}

    # Delete any existing line items
    order.line_items.destroy_all

    # Create blank array
    line_items = []

    in_stock_wholesale_variants.each do |variant|
      # Populate line item array with variant hashes
      line_items << order.contents.create_wholesale_line_item(variant, quantity, options)
    end

    begin
      # Save line item array to order (save only once to reduce load times)
      order.line_items.create!(line_items)
    rescue ActiveRecord::RecordInvalid => e
      error = e.record.errors.full_messages.join(", ")
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    end

    # Update all the totals, checking for relevant taxes or promotions
    order.contents.after_wholesale_add(order, order.line_items, options)

    respond_with(order) do |format|
      format.html { redirect_to cart_path }
    end

  end

end
