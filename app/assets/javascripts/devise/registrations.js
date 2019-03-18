// STATES_DOM_ID = "#get_states"
// CITIES_DOM_ID = "#get_cities"
// ACCOUNT_CITY_INPUT_ID = "#account_city_id"

// GET_STATES_URL = "/locations/get_states"
// GET_CITIES_URL = "/locations/get_cities"
// SEARCH_CITY_PATH = "/locations/search_city?country_id="

// COUNTRY_DOM_ID = "#account_country_id"
// CITY_DOM_ID = "#account_city_id"

// HTTP_METHOD = "POST"
// DATA_TYPE = "html"

// DIV_PESEL_NUMBER = "#pesel-number";
// PESEL_NUMBER_COUNTRY_ABBR = "POL";
// COUNTRY_DIV = "#account_country_id"

// function getStates(country_id) {  
//   $.ajax({
//     url: GET_STATES_URL,
//     type: HTTP_METHOD,
//     data: {"country_id" : country_id},
//     dataType: DATA_TYPE,
//     success: function(data) {
//       $( STATES_DOM_ID ).html(data)
//     }
//   });
// }

// function getCities(country_id) { 
//   $.ajax({
//     url: GET_CITIES_URL,
//     type: HTTP_METHOD,
//     data: {"country_id" : country_id},
//     dataType: DATA_TYPE,
//     success: function(data) {
      
//       $( CITIES_DOM_ID ).html(data);
//       $( ACCOUNT_CITY_INPUT_ID ).autocomplete({
//         source: SEARCH_CITY_PATH + country_id
//       });
//     }
//   });
// }

// function getLocations(country_id) {
//   getStates( country_id );
//   getCities( country_id );
// }


// function showPeselNumber() {
//   if ( $(COUNTRY_DIV + " option").filter(':selected').val() == PESEL_NUMBER_COUNTRY_ABBR ) {
//     $( DIV_PESEL_NUMBER ).show();
//   }
//   else {
//    $( DIV_PESEL_NUMBER ).hide(); 
//   }
// }

// $( document ).ready(function() {
//   $( COUNTRY_DIV ).change(function() {
//     showPeselNumber();
//   });

//   showPeselNumber();
// })


// $( window ).load(function() {

//   $( CITY_DOM_ID ).click(function() {
//     getCities( $( COUNTRY_DOM_ID ).val() );
//   });

// });