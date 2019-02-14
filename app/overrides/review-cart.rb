Deface::Override.new(
  :virtual_path => 'spree/shared/_products',
  :name => 'review-cart',
  :insert_after => "[data-hook='products_list']",
  :partial => "spree/hooks/review_cart",
  :disabled => false
)
