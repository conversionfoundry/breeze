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
  $('#main-tabs-tabs ul.tabs').sortable({
    axis:'x'
  });
  $('#header .menu').sortable({
    axis:'x',
    update: function(e, ui) {
      var data = {};
      //data[$('meta[name=csrf-param]').attr('content')] = $('#edit_content [name=authenticity_token]').val();
      data['_method'] = 'put';
      $('#header .menu li a').each(function() { data += '&user[menu_order][]=' + escape($(this).text()); });
      $.ajax({
        url:'/admin/users/' + $('meta[name=breeze-user-id]').attr('content') + '/preferences',
        data: data,
        type: 'post'
      });
    }
  });
  $('#main-tabs-tabs a.close').live('click', function() {
    close_tab($(this).parent().find('a.tab'));
    return false;
  });
  $('#main-tabs-tabs').each(function() {
    var selected_tab = $(this).find('a[href=' + window.location.hash + ']');
    if (selected_tab.length == 0) { selected_tab = $(this).find('li a').eq(0); }
    selected_tab.closest('li').click();
    return false;
  });
  

  
  // Show a brief message at the top of the screen.
  $.flashMessage = function(message, options) {
    options = options || {}
    $('#flash .flash .close').click();
    $('<div class="flash" style="display: none;">' + message + '<a href="#" class="close">&times;</a></div>').prependTo('#flash').slideDown('fast').each(function() {
      var flash_message = this;
      setTimeout(function() { $(flash_message).slideUp('fast', function() { $(this).remove(); }); }, 2000);
    });
  };
  
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
  
  // Get past the fact that, with multiple forms on a page, IDs aren't necessarily unique
  $('label').live('click', function() {
    var control = $('#' + $(this).attr('for'), $(this).closest('form'));
    if (control.is(':text,textarea')) {
      control.each(function() { this.focus(); });
      return false;
    }
  });
  
  $('a[rel*=error]').live('click', function() {
    $((this.hash == '#page_permalink') ? '#page_slug' : this.hash, $(this).closest('form')).each(function() { this.focus(); });
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

function open_tab(name, url, options) {
  options = options || {}
  if ($('#main-tabs').length > 0) {
    if ((existing = $('#main-tabs-tabs a[href=#tab_' + name + ']')).length > 0) {
      existing.closest('li').click();
    } else {
      if (typeof(options) == 'undefined') { options = {}; }
      var title = options.title || name;
      var tab = '<li class="loading';
      if (options.close) { tab += ' close'; }
      tab += '"><a class="tab" href="#tab_' + name + '">' + title + '</a>';
      if (options.close) { tab += '<a class="close" href="#">&times;</a>'; }
      tab += '</li>';
      $('#main-tabs-tabs ul').append(tab);
      var tab_content = '<div class="tab-pane" id="tab_' + name + '"></div>';
      $('#main-tabs-content').append(tab_content);
      var $tab = $('#main-tabs-tabs li:last'), $pane = $('#tab_' + name);
      if (typeof(options.close) == 'function') {
        $tab.find('a.close').bind('click', options.close);
      }
      $('#main-tabs-tabs li:last').click();
      $('#tab_' + name).load(url, function() {
        $tab.removeClass('loading');
        $('#main-tabs-tabs ul.tabs').sortable('refresh');
        if (options.success) {
          options.success($tab, $pane);
        }
      });
    }
  }
}

function close_tab(a) {
  if (typeof(a) == 'string') { a = 'a[href=#tab_' + a + ']'; }
  $(a).each(function() {
    var tab_name = $(this).attr('href').substring(5);
    $(this).parent().remove();
    $('#main-tabs-content #tab_' + tab_name).remove();
    if ($('#main-tabs-tabs li.active').length == 0) {
      $('#main-tabs-tabs li').eq(0).click();
    }
  });
}
