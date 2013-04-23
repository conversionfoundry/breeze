$(document).ready(function(){
(function($) {
  $.widget("ui.breeze", {
    options: {
      preferences: {
        editing: false,
        toolbar: 'top'
      }
    },
    _init: function() {
      var breeze = this;
      this._loadOptions();
      this._buildToolbar();
      this._augmentRegions();
      this.editing(this.editing());

      $('.editor-panel .buttons-panel a.ok.button').live('click', function() {
        $('#content_new.breeze-content').remove();

        $editor = $(this).closest('.editor-panel');
        $('form:visible', $editor).trigger('submit');
      });

      $('.editor-panel .buttons-panel a.cancel.button').live('click', function() {
        var $form = $(this).closest('.editor-panel').find('form:visible');
        var isNew = $form.is('#new_content');
        if (isNew) {
          $('#content_new.breeze-content').remove();
        } else {
          var href = $form.attr('action').replace('.js', '/live.js');
          var id = $form.attr('action').replace('/admin/contents/', '').replace('.js', '');
          $.ajax({
            url: href,
            success: function(data) {
              $('body').breeze('addContentControls', '#content_' + id);
            }
          });
        }
        $('.editor-panel').removeClass('active').empty();
      });
      
      $('body.breeze-editing .breeze-region-label>a.breeze-add-content').live('click', function() {
        var region = $(this).closest('.breeze-editable-region').attr('data-region');
        var container_id = breeze.options.page_id;
        var url = '/admin/content_type_instances/new?content[page_id]=' +
          breeze.options.page_id + '&content[region]=' +
          $(this).closest('.breeze-editable-region').attr('data-region');
        breeze._openEditorPanel(url, {
          title: 'Add content',
          open: function() {
            $.ajax({
              url: '/admin/contents/add.js',
              data: 'content[region]=' + region + '&content[container_id]=' + container_id,
              success: function(data) {
              }
            });
            breeze.new_content_panel_open(this, url);
          }
        });
        return false;
      });
    },
    option: function(key, value) {
      if (typeof(value) != 'undefined') {
        this.options.preferences[key] = value;
        this._saveOptions();
      }
      return this.options.preferences[key];
    },
    editing: function(toggle) {
      if (typeof(toggle) != 'undefined') {
        $(this.element).toggleClass('breeze-editing', toggle);
        $(this.toolbar).each(function() {
          $('.breeze-toolbar-edit-button', this).toggleClass('active', toggle);
        });
        $('.breeze-editable-region[id]')
          .sortable(toggle ? 'enable' : 'disable')
          .find('>.breeze-region-label').toggle(toggle);
        return this.option('editing', toggle);
      } else return this.option('editing');
    },
    toggle: function() {
      this.editing(!this.editing());
    },
    toolbarPosition: function(position) {
      if (typeof(position) != 'undefined') {
        $('#breeze-toolbar.top').animate({ top: '-48px' }, 'fast', function() {
          $(this).removeClass('top').addClass('bottom')
            .css({ bottom: '-48px', top:'auto' }).animate({ bottom: '0px' }, 'normal', 'easeOutCubic');
        });
        $('#breeze-toolbar.bottom').animate({ bottom: '-48px' }, 'fast', function() {
          $(this).removeClass('bottom').addClass('top')
            .css({ top: '-48px', bottom:'auto' }).animate({ top: '0px' }, 'normal', 'easeOutCubic');
        });

        return this.option('toolbar', position);
      } else return this.option('toolbar');
    },
    addContentControls: function(selector) {
      var breeze = this;
      $(selector).each(function() {
        var id = this.id.replace(/^content_/, '');
        var path = '/admin/contents/' + id;        
        $('<div class="breeze-content-controls" style="display: none"></div>')
          .appendTo(this)
          .hide()
          .append('<a class="edit" href="' + path + '/edit">Edit</a>')
          .append('<a class="duplicate" href="' + path + '/duplicate.js" data-method="post" data-remote="' + path + '/duplicate.js">Duplicate</a>')
          .append('<a class="delete" href="' + path + '.js" data-method="delete" data-confirm="Are you sure you want to delete this content?" data-remote="' + path + '.js">Delete</a>');
        $(this).hover(
          function() { if (breeze.editing()) $(this).addClass('hover').find('>.breeze-content-controls').fadeIn(125); },
          function() { if (breeze.editing()) $(this).removeClass('hover').find('>.breeze-content-controls').fadeOut(250); }
        )
      });
    },
    _loadOptions: function() {
      var saved_options = $.secureEvalJSON($.cookie('breeze-editor') || '{}');
      $.extend(this.options.preferences, saved_options);
    },
    _saveOptions: function() {
      var date = new Date();
      date.setTime(date.getTime() + (10 * 365 * 24 * 60 * 60 * 1000));
      $.cookie('breeze-editor', $.toJSON(this.options.preferences), { path: '/', expires: date });
    },
    _buildToolbar: function() {
      var breeze = this;
      var toolbar_position = breeze.options.preferences.toolbar || 'bottom';
      this.toolbar = $('<div id="breeze-toolbar"></div>').appendTo(this.element)
        .addClass(toolbar_position)
        .css(toolbar_position, '-40px')
        .hover(function() {
          var toolbar_position = breeze.options.preferences.toolbar || 'bottom';
          if (this.hoverOutTimer) { clearTimeout(this.hoverOutTimer); this.hoverOutTimer = null; }
          if (parseInt($(this).css(toolbar_position)) == -40) {
            animation_options = {}; animation_options[toolbar_position] = '0px';
            $(this).animate(animation_options, 'fast', 'easeOutBounce');
          }
        }, function() {
          var toolbar_position = breeze.options.preferences.toolbar || 'bottom';
          if (this.hoverOutTimer) { clearTimeout(this.hoverOutTimer); this.hoverOutTimer = null; }
          var self = this;
          this.hoverOutTimer = setTimeout(function() {
            animation_options = {}; animation_options[toolbar_position] = '-40px';
            $(self).animate(animation_options, 'slow', 'easeOutBack');
            self.hoverOutTimer = null;
          }, 1000);
        });
        
      buttons = $('<span class="breeze-toolbar-item breeze-toolbar-buttons"></span>')
        .appendTo(this.toolbar);
      
      $('<a href="#" class="breeze-toolbar-edit-button" title="Toggle editor">Edit</a>')
        .appendTo(buttons)
        .click(function() {
          breeze.editing(!$(this).hasClass('active'));
          return false;
        });
      
      this.template_selector = $('<div class="breeze-template-chooser breeze-toolbar-item"><label for="breeze_template">Template:</label><select name="page[template]" id="breeze_template"><option value="">(default)</option></select></div>')
        .appendTo(this.toolbar)
        .find('select')
        .each(function() {
          var select = this;
          $.each(breeze.options.templates, function() {
            var label = this.substring(0, 1).toUpperCase() + this.substring(1).replace(/_/g, ' ');
            $(select).append('<option value="' + this + '">' + label + '</option>');
          });
        })
        .val(breeze.options.template)
        .change(function() {
          f = $('<form action="/admin/pages/' + breeze.options.page_id + '" method="post"></form>')
            .append('<input type="hidden" name="' + $('meta[name=csrf-param]').attr('content') + '" value="' + $('meta[name=csrf-token]').attr('content') + '" />')
            .append('<input type="hidden" name="_method" value="put" />')
            .append('<input type="hidden" name="page[template]" value="' + $(this).val() + '" />')
            .appendTo('body')[0].submit();
        });
        
      buttons = $('<span class="breeze-toolbar-item breeze-toolbar-buttons"></span>')
        .appendTo(this.toolbar);

      $('<a href="#" class="breeze-toolbar-position-button" title="Switch top/bottom">Edit</a>')
        .appendTo(buttons)
        .click(function() {
          breeze.toolbarPosition(breeze.toolbarPosition() == 'top' ? 'bottom' : 'top');
          
          return false;
        });

      $('<a href="/admin/pages" class="breeze-admin-button" title="Back to admin">Back to admin</a>')
        .appendTo(buttons);
    },
    _augmentRegions: function() {
      var breeze = this;
      $('.breeze-editable-region[id]').each(function() {
        $(this).attr('data-region', $(this).attr('id').replace(/_region$/, ''));
        $('<div class="breeze-region-label" style="display: none;"><strong>' + $(this).attr('data-region') + '</strong> <a href="#" class="breeze-add-content">+</a></div>')
          .appendTo(this);
      }).sortable({
        items: '>.breeze-content',
        connectWith: '.breeze-editable-region[id]',
        tolerance: 'pointer',
        cursor: 'move',
        placeholder: 'breeze-content-placeholder',
        forcePlaceholderSize: true,
        update: function(e, ui) {
          var orders = new Array();
          $('.breeze-editable-region[id]').each(function() {
            orders.push($(this).sortable('serialize', { key:'page[order][' + this.id.replace(/_region$/, '') + '][]' }));
          });
          var order_string = orders.join('&');
          if (breeze.last_ordering != order_string) {
            breeze.last_ordering = order_string;
            breeze._spinner();
            $.ajax({
              url:'/admin/pages/' + breeze.options.page_id + '/sort.js',
              type:'post',
              dataType:'javascript',
              data: $('meta[name=csrf-param]').attr('content') + "=" + $('meta[name=csrf-token]').attr('content') + '&_method=put&' + order_string,
              complete: function() { breeze._spinner(false); }
            });
          }
        },
        over: function() { $(this).addClass('hover'); },
        out:  function() { $(this).removeClass('hover'); }
      });
      
      breeze.addContentControls('.breeze-editable-region[id] > .breeze-content');
      
      $('.breeze-content-controls .edit').live('click', function() {
        breeze._openEditorPanel($(this).attr('href'), {
          title: 'Edit content',
          open: function() {
            breeze._prepareEditorDialog(this);
          }
        });
        return false;
      });
    },
    _openEditorPanel: function(path, options) {
      var breeze = this;
      $.ajax({
        type: "GET",
        url: path
        }).done(function(html) {
          $dialog = $('.editor-panel');
          $('.editor-panel').html(html);
          $('.editor-panel').addClass('active');
          if (options.open) { 
            options.open.apply($dialog);
          }
        }).fail(function(jqXHR, textStatus) {
          alert( "Request failed: " + textStatus );
      });
    },
    _spinner: function(bool) {
      if (typeof(bool) == 'undefined') { bool = true; }
      if ($('#breeze-spinner').length == 0) { $('<div id="breeze-spinner" style="display: none;"></div>').appendTo('body'); }
      if (bool) {
        $('#breeze-spinner').fadeIn();
      } else {
        $('#breeze-spinner').fadeOut();
      }
    },
    _prepareEditorDialog: function(dialog) {
      var breeze = this;
      $('textarea.markup', dialog).marquess({
        preview: false
      });

      // for live editing

      var typingTimer;                //timer identifier
      var doneTypingInterval = 300;  //time in ms, 5 second for example
      var $form = $('form.content', dialog);
      var isNew = $form.is('#new_content');

      //on keyup, start the countdown
      $(':input:visible').keyup(function(){
        clearTimeout(typingTimer);
        if ($(this).val) {
          typingTimer = setTimeout(doneTyping, doneTypingInterval);
        }
      });

      //user is "finished typing," do something
      function doneTyping () {
        //var $form = $(this).closest('form');
        var href = $form.attr('action').replace('.js', isNew ? '/add.js' : '/live.js');
        $.ajax({
          url: href,
          data: $form.serialize(),
          success: function(data) {
          }
        });
      }

      $(':input:visible', dialog).eq(0).each(function() { this.focus(); });
    },
    new_content_panel_open: function(panel, url) {
      var breeze = this;
      $('#content_new.breeze-content').remove();
      $('.add-content-tabs', panel).tabs({
        selected: 2,
        select: function(e, ui) {
          $('textarea, input[type=search]', ui.panel).eq(0).each(function() { this.focus(); });
        }
      });
      $('#content__type', panel).change(function() {
        $(panel).load(url + '&content[_type]=' + escape($(this).val()), function() {
          breeze.new_content_panel_open(panel, url);
        });
      });
      $('form.search-contents', panel).bind('ajax:success', function(e, data, status, xhr) {
        $('.breeze-search-results', panel)
          .html(data)
          .find('.insert-content-button').button().click(function() {
            var container_id = $('#content_container_id', panel).val();
            var region = $('#content_region', panel).val();
            $.ajax({
              url: $(this).attr('href'),
              type: 'post',
              dataType: 'script',
              data: 'container_id=' + container_id + '&region=' + region 
            });
            return false;
          });
      });
      breeze._prepareEditorDialog(panel);

      $('textarea, input[type=search]', panel).eq(0).each(function() { this.focus(); });
    }
  });
  
  $('.breeze-form a[rel*=error]').live('click', function() {
    $((this.hash == '#page_permalink') ? '#page_slug' : this.hash, $(this).closest('form')).each(function() { this.focus(); });
    return false;
  });
  
  $.ui.marquess.commands['link'].fn = function(editor) {
    $.ui.marquess.current = editor;
    html = $('<div class="marquess-dialog breeze-form"><fieldset><ol class="form"><li class="text_field"><label for="marquess_link_text">Link text<abbr title="required">*</abbr></label><input class="text_field" name="link_text" id="marquess_link_text" /></li><li class="text_field"><label for="marquess_link_url">URL<abbr title="required">*</abbr></label><input class="text_field" name="link_url" id="marquess_link_url" /></li><ul id="marquess_link_select"></ul></div>');
    $(html).dialog({
      title:     'Insert a link',
      width:     480,
      modal:     true,
      resizable: false,
      buttons:   {
        'OK': function() {
          url = $('#marquess_link_url').val();
          if (url[0] != '/' && !(/^https?:\/\//.test(url))) {
            url = 'http://' + url;
          }
          editor.transform({
            defaultText: 'link text',
            text: $('#marquess_link_text').val(),
            before: '[',
            after: '](' + url + ')',
            inline: true
          });
          $(this).dialog("close");
        },
        'Cancel': function() {
          $(this).dialog("close");
        }
      },
      open: function() {
        $('#marquess_link_text', this).val(editor.editor.selectedText()).each(function() { this.focus(); });
        $('#marquess_link_select', this).load('/admin/pages/list', function() {
          $('a', this).click(function() {
            if ($('#marquess_link_text').val() == '') { $('#marquess_link_text').val($(this).text()); }
            $('#marquess_link_url').val($(this).attr('href'));
            return false;
          });
          $('li.open, li.closed').click(function() {
            $(this).toggleClass('open').toggleClass('closed');
            return false;
          }).filter('.open').click();
        });
        $('#marquess_link_text, #marquess_link_url', this).keypress(function(e) {
          if (e.which == 13) {
            $('button:contains(OK)', $(this).closest('.ui-dialog')).click();
            return false;
          }
        });
      },
      close: function() {
        $(this).remove();
      }
    });
  };
  
  $.ui.marquess.commands['image'].fn = function(editor) {
    $.ui.marquess.current = editor;
    
    $.breeze.image_dialog(function(url, title) {
      editor.transform({
        defaultText: 'image title',
        text: title,
        before: '![',
        after: '](' + url + ')',
        inline: true
      });
    }, { upload: true });
    
  };
  
  $('.image_field .browse').live('click', function() {
    var button = this, options = { upload: true }, wrapper = $(this).closest('li');
    if ((w = wrapper.attr('data-width')) && (h = wrapper.attr('data-width'))) {
      options.size = { width:parseInt(w), height:parseInt(h) };
    }
    $.breeze.image_dialog(function(url, title) {
      $('input', wrapper).eq(0).val(url);
    }, options);
    return false;
  });
  
  $.breeze = $.extend({}, {
    image_dialog: function(action, options) {
      options = options || {};
      uploader =  '<div class="file_upload">' + 
                  '  <form accept-charset="UTF-8" action="/admin/assets.json" class="new_content_asset" enctype="multipart/form-data" id="fileupload" method="post">' +
                  '    <input id="content_asset_folder" name="content_asset[folder]" type="hidden" value="/">' + 
                  '    <div id="dropzone" class="drop_zone file_drop_zone">' +
                  '      <div class="drop_zone_icon"></div>' +
                  '      <div class="drop_zone_text">' +
                  '        Drag and drop files here to upload or' +
                  '        <div class="button fileinput-button">' +
                  '          <div class="button_text">Select files from your computer&hellip;</div>' +
                  '          <input id="content_asset_file" multiple="multiple" name="content_asset[file][]" type="file"> ' +
                  '        </div>' +
                  '      </div>' +
                  '    </div>' +
                  '  </form>' + 
                  '</div>';
      html = $('<div class="marquess-dialog marquess-image-dialog breeze-form"><div class="folders-container"><div class="folders"></div></div>' + uploader + '<fieldset><ol class="form"><li><label for="marquess_image_url">Image URL:</label><input class="text" type="text" name="image_url" id="marquess_image_url" /></li><li><label for="marquess_image_title">Image title:</label><input class="text" type="text" name="image_title" id="marquess_image_title" /></li></ol></fieldset></div>');
      $(html).dialog({
        title:     'Insert an image' + (options.size ? '<small>(' + options.size.width + '&times;' + options.size.height + ')</small>' : ''),
        width:     512,
        modal:     true,
        resizable: false,
        buttons:   {
          'OK': function() {
            var dialog = this;
            ok_clicked = function() {
              url = $('#marquess_image_url').val();
              if (!(/^(\/|https?:\/\/)/.test(url))) {
                url = 'http://' + url;
              }
              title = $('#marquess_image_title').val();
              (action)(url, title);
              $(dialog).dialog("close");
            }
            if (options.size && options.selected && (options.size.width != options.selected.width || options.size.height != options.selected.height)) {
              $('<div><p><strong>This image isn\'t the right size: your page might look funny if you use it.</strong></p><p>To use it anyway, click \'<strong>OK</strong>\'.</p><p>Otherwise, click \'<strong>Cancel</strong>\', and then use the \'<strong>Edit</strong>\' button to resize your image.</p></div>').dialog({
                title: 'Warning',
                modal: true,
                resizable: false,
                close: function() { $(this).remove(); },
                buttons: {
                  OK: function() { $(this).dialog('close'); ok_clicked(); },
                  Cancel: function() { $(this).dialog('close'); }
                }
              });
            } else {
              ok_clicked();
            }
          },
          'Cancel': function() {
            $(this).dialog("close");
          }
        },
        open: function() {
          var dialog = this;

          $('#fileupload').fileupload({
              xhrFields: {withCredentials: true},
              dropZone: $('#dropzone'),
              done: function(e, data) {
                // Insert new image into the folder index
                d = data.result;
                $('.folders ul', dialog).last().find('[data-id=' + d.id + ']').remove();
                $('.folders ul', dialog).last().append('<li class="image" data-file="' + d.filename + '" data-title="' + d.title + '" data-width="' + d.width + '" data-height="' + d.height + '" data-id="' + d.id + '"><span>' + d.filename + ' <small>(' + d.width + '&times;' + d.height + ')</small></span></li>');
                $('.folders ul li', dialog).last().click();
              },
              progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progress .bar').css(
                  'width',
                  progress + '%'
                );
              },
              fail: function(e, data) {
                alert('asset upload failed :-(');
              } 
            });

          $.ajax({
            url: '/admin/assets/images.json',
            type: 'get',
            dataType: 'json',
            success: function(data) {
              add_image_folder = function(dialog, name, data) {
                h = $('<ul data-folder="' + name + '"></ul>');
                h.appendTo($('.folders', dialog));
                for (f in data.folders) {
                  h.append('<li class="folder" data-folder="' + f + '"><span>' + f + '</span></li>');
                }
                for (f in data.files) {
                  file = data.files[f];
                  h.append('<li class="image" data-file="' + file.filename + '" data-title="' + escape(file.title || '') + '" data-width="' + (file.width || '') + '" data-height="' + (file.height || '') + '" data-id="' + file.id + '"><span>' + file.filename + ' <small>(' + file.width + '&times;' + file.height + ')</small></span></li>');
                }
                folder_count = $('.folders ul', dialog).length;

                $('.folders', dialog).width(Math.max(folder_count * 200, $('.folders', dialog).parent().width()));
                $('.folders ul', dialog).width(Math.floor($('.folders', dialog).width() / folder_count));
                $('.folders-container', dialog).scrollTo('.folders ul:last-child', dialog);
              };

              dialog.files = data;
              add_image_folder(dialog, '', dialog.files);
              $('.folders li.folder', dialog).live('click', function() {
                $(this).addClass('selected').siblings().removeClass('selected');
                path = '';
                data = dialog.files;
                $(this).closest('ul').nextAll('ul, .image-info').remove();
                $(this).closest('ul').prevAll('ul').each(function() {
                  f = $(this).attr('data-folder');
                  path += f + '/';
                  if (f && f != '') data = data.folders[f];
                });
                f = $(this).closest('ul').attr('data-folder');
                path += f + '/';
                if (f && f != '') data = data.folders[f];
                f = $(this).attr('data-folder');
                path += f + '/';
                if (f && f != '') data = data.folders[f];

                // Tell the upload form which folder to use
                $('#fileupload #content_asset_folder').val(path); 

                add_image_folder(dialog, f, data);
              });

              $('.folders li.image', dialog).live('click', function() {
                $(this).addClass('selected').siblings().removeClass('selected');
                $(this).closest('ul').nextAll('ul, .image-info').remove();
                var info = $('<div class="image-info"></div>').appendTo('.folders', dialog);
                $('.folders', dialog).width(Math.max(folder_count * 200 + 200, $('.folders', dialog).parent().width()));
                $('.folders ul', dialog).width(Math.floor(($('.folders', dialog).width() - 200) / folder_count));
                var path = $.map($('.folders ul', dialog), function(f) { return $(f).attr('data-folder'); }).join('/') + '/' + $(this).attr('data-file');
                $('#marquess_image_url', dialog).val('/assets' + path);
                $('#marquess_image_title', dialog).val($(this).attr('data-title'));
                info.append('<img src="/images/thumbnails/thumbnail/' + path + '" />')
                info.append('<strong>' + $(this).attr('data-file') + '</strong>');
                info.append('<small>' + ($(this).attr('data-width') || '??') + '&times;' + ($(this).attr('data-height') || '??') + '</small>');
                info.append('<a href="/admin/assets/' + $(this).attr('data-id') + '/edit" class="edit button">Edit</a>');
                options.selected = { width:parseInt($(this).attr('data-width')), height:parseInt($(this).attr('data-height')) };
                $('.button', info).button();
                $('.folders-container', dialog).scrollTo('.image-info', dialog);
              });
              
              $('.image-info .edit', dialog).live('click', function() {
                var button = this;
                image_editor({
                  url: this.href,
                  size: options.size,
                  ok: function(dialog) {
                    $.ajax({
                      url: $(button).attr('href').replace(/\/edit$/, '.json'),
                      type: 'post',
                      dataType: 'json',
                      data: $('form:visible', dialog).serialize(),
                      success: function(data) {
                        $('.folders li.image[data-id=' + data.id + ']')
                          .attr('data-width', data.width)
                          .attr('data-height', data.height)
                          .attr('data-title', data.title)
                          .click()
                          .find('small').html('(' + (data.width || '??') + '&times;' + (data.height || '??') + ')');
                        $(dialog).dialog('close');
                      }
                    });
                  }
                });
                return false;
              });
            }
          })
        },
        close: function() {
          $(this).remove();
        }
      });
    }
  });

})(jQuery);
});

// Update the value of the options breeze.page_id
$(function() {
  $("body").breeze({ 
    page_id: $('#page_id').val(), 
    template:"default", 
    templates:['default']
  })
  $("#breeze-template-chooser").val("default")
});

