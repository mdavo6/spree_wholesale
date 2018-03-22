#insert_before :account_my_orders,         'hooks/wholesale_customer'
Deface::Override.new(:virtual_path => 'spree/users/show',
:name => 'wholesale_company_details',
:replace => "dl#user-info",
:partial => "spree/hooks/wholesale_details",
:disabled => false)
