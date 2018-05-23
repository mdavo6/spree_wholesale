Deface::Override.new(
  :virtual_path => 'spree/products/_cart_form',
  :name => 'product-wholesale-price',
  :insert_bottom => "#product-price",
  :partial => "spree/hooks/product_wholesale_price",
  :disabled => false
)
