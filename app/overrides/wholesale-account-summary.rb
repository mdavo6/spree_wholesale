#insert_before :account_my_orders,         'hooks/wholesale_customer'
Deface::Override.new(:virtual_path => 'spree/users/show',
:name => 'wholesale-account-summary',
:replace => "[data-hook='account_summary']",
:partial => "spree/hooks/wholesale_account_summary",
:disabled => true)
