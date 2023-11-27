Deface::Override.new(
  virtual_path: "spree/admin/users/edit",
  name: "login_link",
  insert_after: "[data-hook='admin_user_edit_general_settings']",
  partial: "spree/admin/users/login_link",
  original: 'c295a231cb6869dea88c2a6bdf73e502ae3a338e',
  disabled: false
)
