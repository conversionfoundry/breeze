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
  
  $('#left .sliding .pages').each(function() {
    var pages = $(this).find('.page');
    var w = parseInt($(this).parent().css('width'));
    pages.each(function(i) {
      $(this).css({ width: w + 'px', left:(w*i) + 'px' });
    });
  });
  
  $('.sliding a.back').live('click', function() {
    advance_slider($(this).closest('.sliding'), -1);
    return false;
  });
  
  $('#left #themes .theme a').live('click', function() {
    var $this = $(this);
    $this.addClass('loading');
    $.get(this.href, function(data) {
      $this.removeClass('loading');
      var $page = $this.closest('.pages').find('.page:eq(1)');
      $page.find('.header h2').text($this.find('strong').text());
      $page.find('.inner').html(data);
      advance_slider($this.closest('.sliding'), 1);
    });
    return false;
  });
  
  $('#left .theme-status a.enable, #left .theme-status a.disable').live('click', function() {
    var $this = $(this);
    $.ajax({
      url: this.href,
      type: 'post',
      dataType: 'script',
      data: '_method=put'
    });
    return false;
  });
});

function advance_slider(selector, direction) {
  $(selector).find('.pages').each(function() {
    var w = parseInt($(this).parent().css('width'));
    var p = Math.round(parseInt($(this).css('left')) / -w);
    $(this).animate({ left: ((p + direction) * -w) + 'px' });
  });
}
