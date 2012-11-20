$(function() {
  $('.new.user.button').click(function() {
    open_tab('new_user', '/admin/users/new', {
      title: 'New user',
      close: true,
      success: function(tab, pane) {
        renumber_fields(pane);
      }
    });
    return false;
  });

  $('#left #users a[data-id]').live('click', function() {
    open_tab($(this).attr('data-id'), $(this).attr('href'), {
      title: $('strong', this).text(),
      close: true
    });
    return false;
  });
  
  if (window.location.hash) {
    $('#left #users a[data-id=' + window.location.hash.substring(1) + ']').click();
  }
});