Deface::Override.new(
  virtual_path: "spree/admin/users/edit",
  name: "login_link",
  insert_after: "[data-hook='admin_user_api_key']",
  partial: "spree/admin/users/login_link")
