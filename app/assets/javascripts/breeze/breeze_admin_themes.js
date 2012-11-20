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
    data = {};
    data[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
    data['_method'] = 'put';
    $.ajax({
      url: this.href,
      type: 'post',
      dataType: 'script',
      data: data /* '_method=put' */
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
    $('#left #theme_files').tree({
      ui: {
        dots: false,
        selected_delete: false
      },
      plugins: {
        contextmenu: {
          items: {
            rename: {
  						visible	: function (NODE, TREE_OBJ) { if(NODE.length != 1) return false; return TREE_OBJ.check("renameable", NODE) && $(NODE).attr('rel') != 'root'; },
  					},
  					remove: {
  					  action	: function (NODE, TREE_OBJ) {
  					    var message = $(this).attr('data-confirm') || 'Are you sure you want to delete this?';
                $('<p>' + message + '</p>').dialog({
                  modal: true,
                  resizable: false,
                  buttons: {
                    Delete: function() {
                      $(this).dialog('close');
                      $.each(NODE, function () { TREE_OBJ.remove(this); });
                    },
                    Cancel: function() {
                      $(this).dialog('close');
                    }
                  },
                  title:'Confirm delete'
                });
  					  }
  					}
  				}
        }
      },
      types: {
        'default': {
          'delete': true,
          'deletable': true,
          'rename': true,
          'create': true
        },
        'special': {
          'rename': false,
          'deletable': false,
          'start_drag': false,
          'move_node': false
        },
        'file': {
          'create': false,
          valid_children: []
        },
        'folder': {
          valid_children: [ 'file', 'folder' ]
        }
      },
      rules: {
        multiple: false,
        drag_copy: false
      },
      callback: {
        onselect: function(node, tree) {
          a = $(node).children('a');
          url = $(a).attr('href');
          if (url != '') {
            name = url.substring(1);
            title = name.replace(/^([^\/]*\/)*/, '');
            name = name.replace(/[\/\. ]/g, '-');
            open_tab(name, url.replace(/ /g, '+'), {
              close:true,
              title:title,
              success: function(tab, pane) {
                $('textarea', pane).each(function() {
                  var options = {
                    height: $(this).height(),
                    path: "/cached/breeze/codemirror/js/",
                    stylesheet: ["/cached/breeze/codemirror/css/xmlcolors.css", "/cached/breeze/codemirror/css/jscolors.css", "/cached/breeze/codemirror/css/csscolors.css"]
                  };
                  if (/\.js$/.test(url)) {
                    options.parserfile = ["tokenizejavascript.js", "parsejavascript.js"];
                    options.autoMatchParens = true;
                  } else if (/\.css$/.test(url)) {
                    options.parserfile = ["parsecss.js"];
                    options.autoMatchParens = true;
                  } else {
                    options.parserfile = ["parsexml.js", "parsecss.js", "tokenizejavascript.js", "parsejavascript.js", "parsehtmlmixed.js"];
                  }
                  var editor = CodeMirror.fromTextArea(this, options);
                });
                
                // $('iframe textarea', pane).each(function() { this.focus(); });
              }
            });
          }
        },
        onrename: function(node, tree) {
          var a = $('>a', node), name = get_file_or_folder_name(node);
          if (a.attr('href') != '') {
            $.ajax({
              url: a.attr('href'),
              data: '_method=put&' + ($(node).hasClass('folder') ? 'folder' : 'file') + '[name]=' + escape(name),
              type: 'post'
            });
          } else {
            var parent_href = $('>a', $(node).parent().closest('li')).attr('href');
            // New file or folder
            if (/\.\w+$/.test(name)) {
              parent_href = parent_href.replace(/^\/admin\/themes\/([^\/]+)\/folders/, '/admin/themes/$1/files');
              tree.set_type('file', node);
              file_name = get_file_or_folder_name(node);
              path = parent_href + '/' + file_name;
              $.ajax({
                url: path,
                type: 'post',
                data: '_method=put',
                success: function() {
                  $('>a', node).attr('href', path).click().parent().addClass(file_name.replace(/^.*\.([^\.]+)$/, '$1'));
                }
              });
            } else {
              $(node).addClass('folder');
              tree.set_type('folder', node);
              folder_name = get_file_or_folder_name(node);
              $.ajax({
                url: parent_href,
                type: 'post',
                data: 'folder[name]=' + folder_name,
                success: function() {
                  $('>a', node).attr('href', parent_href + '/' + folder_name).click();
                }
              });
            }
          }
        },
        onmove: function(node, ref, type, tree, rollback) {
          // TODO: implement!
          $.flashMessage('Sorry, dragging and dropping of files and folders is not implemented yet.', { auto: false });
          $.tree.rollback(rollback);
        },
        ondelete: function(node, tree) {
          $.ajax({
            url: $('>a', node).attr('href'),
            type: 'post',
            data: '_method=delete'
          });
        }
      }
    });
    
    if (options.open) {
      $.each(options.open, function(i, folder) {
        var node = $('#left #theme_files a[href=' + folder + ']');
        $.tree.reference('#left #theme_files').open_branch(node, true);
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

function get_file_or_folder_name(node) {
  return $('a', node).contents().filter(function() { return this.nodeType == 3; }).eq(0).text();
}
