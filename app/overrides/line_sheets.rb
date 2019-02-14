Deface::Override.new(
  :virtual_path => 'spree/users/show',
  :name => 'new-order-link',
  :insert_after => "[data-hook='account_summary']",
  :partial => "spree/hooks/line_sheets",
  :disabled => false
)
