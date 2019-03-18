// $(function() {
  // $("#verify-btn").click(function(){
  //   var complete = function() { console.log("1312")};
  //   iamreal.verify3d(guid, complete());
  // });
// })


function onComplete(msg) {
  var params = { complete: msg };
  console.log(msg);
  
  $.post("/verification/iamreal", params)
    .done(function( data ) {
      //console.log(data);
      
      window.location.href = "/verification";
  });
}
;
