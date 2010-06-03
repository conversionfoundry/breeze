$(function() {
  $('#left #users a[data-id]').click(function() {
    open_tab($(this).attr('data-id'), $(this).attr('href'), {
      title: $('strong', this).text(),
      close: true
    });
    return false;
  });
});