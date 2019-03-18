function BtnConstruct() {

  this.amount_of_checked = 0;

  this.change = function () {
    var checkboxes = jQuery("#agreements_form input[type=checkbox]");
    var self = this;

    jQuery.each(checkboxes, function(index, checkbox) {
      $( checkbox ).click(function(){
        if ( this.checked ) {
          self.amount_of_checked += 1;
        } 
        else {
          self.amount_of_checked -= 1;
        };

        self.change_btn_status(self.amount_of_checked);
      });
    });
  };


  this.change_btn_status = function(amount_of_checkboxes) {
    var count = ("#agreements_form input[type=checkbox]").size();

    ((amount_of_checkboxes == count) ? this.btn_switcher("enable") : this.btn_switcher("disable"));
  };

  this.btn_switcher = function(state) {
    var btn = $("#agree_with_terms");
    
    switch(state) {
      case "disable":
        btn.prop("disabled", true);
        break;
      case "enable":
        btn.removeProp("disabled");
        break;
    };
  };

};


jQuery( document ).ready(function() {
  var inst = new BtnConstruct();
  inst.change();
});
