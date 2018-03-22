#insert_before :account_my_orders,         'hooks/wholesale_customer'
Deface::Override.new(:virtual_path => 'spree/users/show',
:name => 'wholesaler_title',
:replace => "h1",
:partial => "spree/hooks/wholesaler_title",
:disabled => false)
