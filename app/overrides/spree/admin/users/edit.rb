Deface::Override.new(
  virtual_path: "spree/admin/users/edit",
  name: "login_link",
  insert_after: "[data-hook='admin_user_edit_general_settings']",
  partial: "spree/admin/users/login_link")
