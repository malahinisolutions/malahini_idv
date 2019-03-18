VERIFY_BTN = "a.verify"
SUBMIT_PERSONAL_DATA_BTN = "#submit-personal-data" 
MODAL_WINDOW = "#loaderModal"

function showModal( btn_id ) {
  $( btn_id ).click(function() {
    $( MODAL_WINDOW ).modal("show");
  });
}

$( window ).load(function() {
  // showModal( SUBMIT_PERSONAL_DATA_BTN );
  // showModal( VERIFY_BTN );
});

STATES_DOM_ID = "#get_states"
CITIES_DOM_ID = "#get_cities"
ACCOUNT_CITY_INPUT_ID = "#city_id"

GET_STATES_URL = "/locations/get_states"
GET_CITIES_URL = "/locations/get_cities"
SEARCH_CITY_PATH = "/locations/search_city?country_id="

CITY_DOM_ID = "#city_id"
COUNTRY_DIV = "#country_id"

HTTP_METHOD = "POST"
DATA_TYPE = "html"

DIV_PESEL_NUMBER = "#pesel-number";
PESEL_NUMBER_COUNTRY_ABBR = "POL";

function getStates(country_id) {  
  $.ajax({
    url: GET_STATES_URL,
    type: HTTP_METHOD,
    data: {"country_id" : country_id},
    dataType: DATA_TYPE,
    success: function(data) {
      $( STATES_DOM_ID ).html(data)
    }
  });
}

function getCities(country_id) { 
  $.ajax({
    url: GET_CITIES_URL,
    type: HTTP_METHOD,
    data: {"country_id" : country_id},
    dataType: DATA_TYPE,
    success: function(data) {
      
      $( CITIES_DOM_ID ).html(data);
      $( ACCOUNT_CITY_INPUT_ID ).autocomplete({
        source: SEARCH_CITY_PATH + country_id
      });
    }
  });
}

function getLocations(country_id) {
  getStates( country_id );
  getCities( country_id );
}


function showPeselNumber() {
  if ( $(COUNTRY_DIV + " option").filter(':selected').val() == PESEL_NUMBER_COUNTRY_ABBR ) {
    $( DIV_PESEL_NUMBER ).show();
  }
  else {
   $( DIV_PESEL_NUMBER ).hide(); 
  }
}

$( document ).ready(function() {
  $( COUNTRY_DIV ).change(function() {
    showPeselNumber();
  });

  showPeselNumber();
})


$( window ).load(function() {

  $( CITY_DOM_ID ).click(function() {
    getCities( $( COUNTRY_DIV ).val() );
  });

});
