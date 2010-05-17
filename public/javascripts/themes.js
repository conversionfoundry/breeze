$(function() {
  $('#left #themes').sortable({
    axis: 'y',
    items: '>.theme',
    update: function(e, ui) {
      $.ajax({
        url: '/admin/themes/reorder',
        type: 'post',
        data: '_method=put&' + $(this).sortable('serialize')
      });
    }
  });
  
  $('#left #themes .theme a').live('click', function() {
    open_theme_folder(this);
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
  
  $('form.editor').live('submit', function() {
    $(':input', this).each(function() { this.blur(); });
    var save_overlay = $('<div class="overlay" style="display: none;"><h3>Saving…</h3></div>').appendTo($(this)).fadeIn();
    
  });
  
  $('form.new.folder').live('ajax:success', function() {
    this.reset();
  });
  
  $('form.editor textarea').live('keydown', function(e) {
    // TODO: tab support
    if (e.metaKey || e.ctrlKey) {
      switch(String.fromCharCode(e.which).toLowerCase()) {
      case 's':
        $(this).closest('form').submit();
        return false;
      }
    }
  });
  
  $('#left #theme_files a').live('click', function() {
    var item = $(this).closest('li');
    name = $(this).attr('href').substring(1);
    title = name.replace(/^([^\/]*\/)*/, '');
    name = name.replace(/[\/\.]/g, '-');
    open_tab(name, this.href, {
      close:true,
      title:title,
      success: function(tab, pane) {
      }
    });
  });
});

function open_theme_folder(theme_link, options) {
  options = options || {}
  var $this = $(theme_link);
  $this.addClass('loading');
  $.get(theme_link.href, function(data) {
    $this.removeClass('loading');
    var $page = $this.closest('.pages').find('.page:eq(1)');
    $page.find('.header h2').text($this.find('strong').text());
    $page.find('.inner').html(data);
    $this.closest('.sliding').each(function() {
      if (parseInt($('.pages', this).css('left')) == 0) { 
        advance_slider($(this), 1);
      }
    });
    $('#left #theme_files').jstree({
      themes: {
        theme: 'breeze',
        dots: false
      },
      animation:false
    }).find('>ul').addClass('jstree-no-checkboxes');
    
    if (options.open) {
      $.each(options.open, function(i, folder) {
        var node = $('#left #theme_files a[href=' + folder + ']');
        $.jstree._reference('#left #theme_files').open_node(node);
      });
    }
    
    if (options.selected) {
      $('#left #theme_files a[href=' + options.selected + ']').click();
    }
  });
}

function get_open_theme_folders() {
  return $.map($('#left .jstree-open>a'), function(a, i) { return $(a).attr('href'); });
}