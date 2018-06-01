Deface::Override.new(
  :virtual_path => 'spree/shared/_user_form',
  :name => 'wholesale-user-signup-field',
  :insert_top => "[data-hook='signup_below_password_fields']",
  :partial => "spree/hooks/wholesale_user_signup_field",
  :disabled => false
)
