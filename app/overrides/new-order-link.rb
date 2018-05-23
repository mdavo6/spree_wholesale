Deface::Override.new(
  :virtual_path => 'spree/users/show',
  :name => 'new-order-link',
  :insert_after => "h3",
  :partial => "spree/hooks/new_order_link",
  :disabled => false
)
