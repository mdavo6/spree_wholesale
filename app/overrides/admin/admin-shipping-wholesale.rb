# insert_after ".tax_categories,    'admin/hooks/admin_shipping_wholesale'
Deface::Override.new(:virtual_path => 'spree/admin/shipping_methods/_form',
:name => 'admin-shipping-wholesale',
:insert_after => ".tax_categories",
:partial => "spree/admin/hooks/admin_shipping_wholesale",
:disabled => false)
