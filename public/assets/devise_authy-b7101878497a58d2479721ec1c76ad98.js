jQuery.noConflict()(function($) {
  $('a#authy-request-sms-link').unbind('ajax:success');
  $('a#authy-request-sms-link').bind('ajax:success', function(evt, data, status, xhr) {

    var image = data.sent == false ? 'error.png' : 'success.png';

    $.gritter.add({
      title: 'Message',
      text: data.message,
      image: '/assets/' + image,
      time: 2000,
    });
  });
});

