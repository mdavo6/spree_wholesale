Deface::Override.new(
  :virtual_path => 'spree/users/show',
  :name => 'new_order_link',
  :insert_after => "h3",
  :partial => "spree/hooks/new_order_link",
  :disabled => false
)
