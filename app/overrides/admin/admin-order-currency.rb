#insert_after :admin_orders_index_headers, 'admin/hooks/admin_orders_index_headers'
Deface::Override.new(:virtual_path => 'spree/admin/orders/cart',
:name => 'admin-order-currency',
:insert_before => "[data-hook='admin_order_edit_header']",
:partial => "spree/admin/hooks/admin_order_currency",
:disabled => false)
