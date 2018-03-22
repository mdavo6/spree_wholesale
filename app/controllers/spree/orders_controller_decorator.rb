Spree::OrdersController.class_eval do

  def wholesale
    order    = current_order(create_order_if_necessary: true)
    variants  = Spree::Variant.all
    quantity = 0
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.

    variants.each do |variant|

      if quantity.between?(0, 2_147_483_647)
        begin
          if order.is_wholesale? && variant.is_wholesaleable?
            order.contents.add_wholesale(variant, quantity, options)
          else
            order.contents.add(variant, quantity, options)
          end
        rescue ActiveRecord::RecordInvalid => e
          error = e.record.errors.full_messages.join(", ")
        end
      else
        error = Spree.t(:please_enter_reasonable_quantity)
      end

      if error
        flash[:error] = error
        redirect_back_or_default(spree.root_path)
      end

    end

    respond_with(order) do |format|
      format.html { redirect_to cart_path }
    end
  end

end
