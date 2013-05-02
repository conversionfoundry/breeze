$('#forgot a.forgot').click(function() {
  $('#forgot input[type=text]').val($('#admin_email').val());
  $('#forgot_form').slideToggle();
  $('#forgot').toggleClass('active');
  return false;
});
