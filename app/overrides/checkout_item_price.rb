Deface::Override.new(
  :virtual_path => 'spree/checkout/_delivery',
  :name => 'checkout_item_price',
  :replace => "td.item-price",
  :partial => "spree/hooks/checkout_item_price",
  :disabled => false
)
