$(document).ready(function() {

  var wholesaler_visible_address_string = $('select#wholesaler_visible_address_string');

  var address_visibility = function () {
    if (wholesaler_visible_address_string.val() == "Another Address") {
      $('#visible-address-wrapper').show();
    } else {
      $('#visible-address-wrapper').hide();
    }
  };

  wholesaler_visible_address_string.click(function() {
    address_visibility();
  });

  address_visibility();

});
