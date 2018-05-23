Deface::Override.new(:virtual_path => 'spree/shared/_user_form',
:name => 'admin-wholesaler-user',
:replace => "[data-hook='signup_below_password_fields']",
:partial => "spree/admin/hooks/wholesale_user_field",
:disabled => false)
