#insert_after :admin_orders_index_headers, 'admin/hooks/admin_orders_index_headers'
Deface::Override.new(:virtual_path => 'spree/layouts/admin',
:name => 'admin-wholesalers-tab',
:insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
:partial => "spree/admin/hooks/wholesalers_tab",
:disabled => false)
