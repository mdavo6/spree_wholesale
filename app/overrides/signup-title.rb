Deface::Override.new(:virtual_path => 'spree/user_registrations/new',
:name => 'signup-title',
:replace => "#new-customer > h1",
:partial => "spree/hooks/signup_title",
:disabled => false)
