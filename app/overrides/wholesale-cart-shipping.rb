Deface::Override.new(:virtual_path => 'spree/orders/edit',
:name => 'wholesale-cart-shipping',
:insert_after => "[data-hook='cart_items']",
:partial => "spree/hooks/wholesale_cart_shipping",
:disabled => false)
