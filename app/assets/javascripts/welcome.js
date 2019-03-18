function BtnConstruct() {  
  this.change_button = function() {
    var btn = $("#agree_with_terms");
    
    if ($('#_terms_of_use').prop('checked')) {
        btn.removeProp("disabled");
    } else {        
        btn.prop("disabled", true);
    }
  };
}

jQuery( document ).ready(function() {
  var inst = new BtnConstruct();
  $('#_terms_of_use').click(function(){
    inst.change_button();
  });
  inst.change_button();
});