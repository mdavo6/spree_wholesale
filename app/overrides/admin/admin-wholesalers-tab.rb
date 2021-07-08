#insert_after :admin_orders_index_headers, 'admin/hooks/admin_orders_index_headers'
Deface::Override.new(:virtual_path => 'spree/admin/shared/_main_menu',
:name => 'admin-wholesalers-tab',
:insert_bottom => 'nav',
:partial => "spree/admin/hooks/wholesalers_tab",
:disabled => false)
