$(function() {
  $('#main-tabs-tabs li').live('click', function() {
    if (!$(this).hasClass('active')) {
      $('#main-tabs-tabs li').removeClass('active');
      $('#main-tabs-content .tab-pane').hide();
      $(this).addClass('active');
      $('#main-tabs-content ' + $(this).find('a').attr('href')).show();
    }
    return false;
  });
  $('#main-tabs-tabs li a.close').live('click', function() {
    close_tab($(this).closest('li'));
    return false;
  });
  $('#main-tabs-tabs').each(function() {
    var selected_tab = $(this).find('a[href=' + window.location.hash + ']');
    if (selected_tab.length == 0) { selected_tab = $(this).find('li a').eq(0); }
    selected_tab.closest('li').click();
    return false;
  });
  
  $('.flash .close').live('click', function() {
    $(this).closest('.flash').slideUp('fast', function() { $(this).remove(); });
    return false;
  });
});
