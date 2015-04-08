var MailMerge = MailMerge || {};

$.ajaxSetup ({
   cache: false
});

jQuery(function() {
  $(document).foundation();

  $('form[ajax-form]').submit(function(e) {
    var action = $(this).attr('action');
    var params = $(this).serialize();
    var callback = $(this).attr('ajax-callback');

    $.post(action, params)
      .done(function(response) { window["MandrillMerge"].app[callback](jQuery.parseJSON(response)); })
      .fail(function(response) { alert('something went wrong'); });

    e.preventDefault();
  });
});