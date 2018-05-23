//= require_self
$(document).ready(function() {

  var wholesaler_use_billing_input = $('input#wholesaler_use_billing');

  var wholesaler_use_billing = function () {
    if (!wholesaler_use_billing_input.is(':checked')) {
      $('#shipping').show();
    } else {
      $('#shipping').hide();
    }
  };

  wholesaler_use_billing_input.click(function() {
    wholesaler_use_billing();
  });

  wholesaler_use_billing();

});
