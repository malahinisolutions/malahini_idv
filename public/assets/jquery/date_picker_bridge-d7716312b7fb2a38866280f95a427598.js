jQuery(function($){
  if (typeof($.datepicker) === 'object') {
    $.datepicker.regional['en'] = {"closeText":"Close","prevText":"Previous","nextText":"Next","currentText":"Today","monthNames":["January","February","March","April","May","June","July","August","September","October","November","December"],"monthNamesShort":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"dayNames":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"dayNamesShort":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"dayNamesMin":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"changeYear":true,"changeMonth":true,"firstDay":0,"isRTL":false,"showMonthAfterYear":false,"weekHeader":"Wk","dateFormat":"yy-mm-dd"};
    $.datepicker.setDefaults($.datepicker.regional['en']);
  }
  if (typeof($.timepicker) === 'object') {
    $.timepicker.regional['en'] = {"ampm":false,"hourText":"Hour","minuteText":"Minute","secondText":"Seconds","closeText":"Close","currentText":"Now","timeText":"Hour","dateFormat":"D, dd M yy","timeFormat":"HH:mm:ss"};
    $.timepicker.setDefaults($.timepicker.regional['en']);
  }
});
Object.getPrototypeOf(jQuery.datepicker)._attachDatepicker_without_inlineSettings = Object.getPrototypeOf(jQuery.datepicker)._attachDatepicker;
jQuery.extend(Object.getPrototypeOf(jQuery.datepicker), {
  _attachDatepicker: function(target, settings) {
    var inlineSettings = {}, $target = jQuery(target);
    for (var attrName in this._defaults) {
      if(this._defaults.hasOwnProperty(attrName)){
        var attrValue = $target.data(attrName.toLowerCase());
        if (attrValue) {
          try {
            inlineSettings[attrName] = eval(attrValue);
          } catch (err) {
            inlineSettings[attrName] = attrValue;
          }
        }
      }
    }
    this._attachDatepicker_without_inlineSettings(target, jQuery.extend({}, settings || {}, inlineSettings));
  }
});
jQuery(document).on("focus", "input.date_picker", function(){
  var date_picker = jQuery(this);
  if (typeof(date_picker.datepicker) == 'function') {
    if (!date_picker.hasClass('hasDatepicker')) {
      date_picker.datepicker();
      date_picker.trigger('focus');
    }
  }
  return true;
});

jQuery(document).on("focus", "input.datetime_picker", function(){
  var date_picker = jQuery(this);
  if (typeof(date_picker.datetimepicker) == 'function') {
    if (!date_picker.hasClass('hasDatepicker')) {
      date_picker.datetimepicker();
      date_picker.trigger('focus');
    }
  }
  return true;
});
