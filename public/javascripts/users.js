$(function() {
  $('#left #users a[data-id]').click(function() {
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