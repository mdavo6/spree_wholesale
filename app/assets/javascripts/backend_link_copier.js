var SpreeLinkCopy = function(linkCode, copyLinkCode){
  this.linkCode = $(linkCode);
  this.copyLinkCode = $(copyLinkCode);
}

SpreeLinkCopy.prototype.bindEvents = function() {
  var _this = this;
  this.copyLinkCode.on('click', function() {
    _this.linkCode.select()
    document.execCommand("copy")
  })
}

$(document).ready(function() {
  var spreeLinkCopy = new SpreeLinkCopy("[data-link-code]", "[data-copy-link-code]")
  spreeLinkCopy.bindEvents()
  var spreeLinkCopyUS = new SpreeLinkCopy("[data-link-code-us]", "[data-copy-link-code-us]")
  spreeLinkCopyUS.bindEvents()
})
