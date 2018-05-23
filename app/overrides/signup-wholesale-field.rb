Deface::Override.new(
  :virtual_path => 'spree/user_registrations/new',
  :name => 'signup-wholesale-field',
  :insert_top => "[data-hook='signup_inside_form']",
  :partial => "spree/hooks/signup_wholesale_field",
  :disabled => false
)
