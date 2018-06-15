Deface::Override.new(:virtual_path => 'spree/orders/edit',
:name => 'wholesale-cart-message',
:insert_top => "[data-hook='outside_cart_form']",
:partial => "spree/hooks/wholesale_cart_message",
:disabled => false)
