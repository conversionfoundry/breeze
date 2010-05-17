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
    var $this = $(this);
    $this.addClass('loading');
    $.get(this.href, function(data) {
      $this.removeClass('loading');
      var $page = $this.closest('.pages').find('.page:eq(1)');
      $page.find('.header h2').text($this.find('strong').text());
      $page.find('.inner').html(data);
      advance_slider($this.closest('.sliding'), 1);
      $('#left #theme_files').jstree({
        themes: {
          theme: 'breeze',
          dots: false
        }
      }).find('>ul').addClass('jstree-no-checkboxes');
      $('#left #theme_files a').live('click', function() {
        if ($(this).closest('li').hasClass('file')) {
          name = $(this).attr('href').substring(1);
          title = name.replace(/^([^\/]*\/)*/, '');
          name = name.replace(/[\/\.]/g, '-');
          open_tab(name, this.href, {
            close:true,
            title:title,
            success: function(tab, pane) {
            }
          });
        }
      });
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
  
  $('form.editor').live('submit', function() {
    $(':input', this).each(function() { this.blur(); });
    var save_overlay = $('<div class="overlay" style="display: none;"><h3>Saving…</h3></div>').appendTo($(this)).fadeIn();
    
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
});