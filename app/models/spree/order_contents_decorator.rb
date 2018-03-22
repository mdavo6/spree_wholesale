Spree::OrderContents.class_eval do

  def add_wholesale(variant, quantity = 1, options = {})
    timestamp = Time.current

    #Replace retail price with wholesale price
    if variant.wholesale_price > 0
      variant.price = variant.wholesale_price
    end

    line_item = add_to_line_item(variant, quantity, options)
    options[:line_item_created] = true if timestamp <= line_item.created_at
    after_add_or_remove(line_item, options)
  end

end
