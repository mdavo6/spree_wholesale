Deface::Override.new(
  :virtual_path => 'spree/admin/prices/_variant_prices',
  :name => 'admin-wholesale-prices',
  :replace => 'div.panel-body, div.no-padding-bottom',
  :partial => 'spree/admin/hooks/admin_wholesale_prices',
  :disabled => false
)
