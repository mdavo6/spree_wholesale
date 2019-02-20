Deface::Override.new(
  :virtual_path => 'spree/shared/_products',
  :name => 'products-wholesale-pricing',
  :replace => "[data-hook='products_list_item'] .price.selling",
  :partial => "spree/hooks/products_wholesale_pricing",
  :disabled => true
)
