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
      this._loadStylesheet();
      this._loadStylesheet('/breeze/javascripts/marquess/marquess.css'); // TODO: incorporate into main stylesheet
      this._buildToolbar();
      this._augmentRegions();
      this.editing(this.editing());
      
      $('body.breeze-editing .breeze-region-label>a.breeze-add-content').live('click', function() {
        var url = '/admin/contents/new?content[container_id]=' + breeze.options.page_id + '&content[region]=' + $(this).closest('.breeze-editable-region').attr('data-region') + '&content[view]=' + breeze.options.view;
        breeze._openDialog(url, {
          title: 'Add content',
          open: function() {
            breeze.new_content_dialog_open(this, url);
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
      $(selector).each(function() {
        var id = this.id.replace(/^content_/, '');
        var path = '/admin/contents/' + id;        
        $('<div class="breeze-content-controls"></div>')
          .appendTo(this)
          .hide()
          .append('<a class="edit" href="' + path + '/edit">Edit</a>')
          .append('<a class="duplicate" href="' + path + '/duplicate.js" data-method="post" data-remote="' + path + '/duplicate.js">Duplicate</a>')
          .append('<a class="delete" href="' + path + '.js" data-method="delete" data-remote="' + path + '.js">Delete</a>');
        $(this).hoverIntent({
          timeout: 500,
          over: function() { $(this).addClass('hover').find('>.breeze-content-controls').fadeIn(125); },
          out:  function() { $(this).removeClass('hover').find('>.breeze-content-controls').fadeOut(250); }
        })
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
    _loadStylesheet: function(href) {
      $('<link rel="stylesheet" type="text/css" href="' + (href || '/breeze/editor/editor.css') + '" />')
        .appendTo('head');
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
        
      this.view_selector = $('<div class="breeze-view-chooser breeze-toolbar-item"><label for="breeze_view">View:</label><select name="page[view]" id="breeze_view"><option value="">(default)</option></select></div>')
        .appendTo(this.toolbar)
        .find('select')
        .each(function() {
          var select = this;
          $.each(breeze.options.views || [], function() {
            var label = this.substring(0, 1).toUpperCase() + this.substring(1).replace(/_/g, ' ');
            $(select).append('<option value="' + this + '">' + label + '</option>');
          });
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
        $('<div class="breeze-region-label"><strong>' + $(this).attr('data-region') + '</strong> <a href="#" class="breeze-add-content">+</a></div>')
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
          var view = breeze.toolbar.find('#breeze_view').val();
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
              data:'_method=put&page[view]=' + view + '&' + order_string,
              complete: function() { breeze._spinner(false); }
            });
          }
        },
        over: function() { $(this).addClass('hover'); },
        out:  function() { $(this).removeClass('hover'); }
      });
      
      breeze.addContentControls('.breeze-editable-region[id] > .breeze-content');
      
      $('.breeze-content-controls .edit').live('click', function() {
        breeze._openDialog($(this).attr('href'), {
          title: 'Edit content',
          open: function() {
            breeze._prepareEditorDialog(this);
          }
        });
        return false;
      });
    },
    _openDialog: function(path, options) {
      var breeze = this;
      breeze._spinner();
      
      $.get(path, function(data) {
        breeze._spinner(false);
        options = $.extend({
          modal: true,
          resizable: false,
          width: 640,
          buttons: {
            Cancel: function() {
              $(this).dialog('close');
            },
            OK: function() {
              $('form:visible', $(this).closest('.ui-dialog')).trigger('submit');
            }
          },
          close: function() {
            $(this).remove();
          }
        }, options || {});
        $('<div></div>').html(data).appendTo('body').dialog(options);
        // $('button.ui-button:contains("OK"):not(.green)').addClass('green');
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
      $(':input:visible', dialog).eq(0).each(function() { this.focus(); });
    },
    new_content_dialog_open: function(dialog, url) {
      var breeze = this;
      $('.add-content-tabs', dialog).tabs({
        selected: 1,
        select: function(e, ui) {
          $('textarea, input[type=search]', ui.panel).eq(0).each(function() { this.focus(); });
        }
      });
      $('#content__type', dialog).change(function() {
        $(dialog).load(url + '&content[_type]=' + escape($(this).val()), function() {
          breeze.new_content_dialog_open(dialog, url);
        });
      });
      $('form.search-contents', dialog).bind('ajax:success', function(e, data, status, xhr) {
        $('.breeze-search-results', dialog)
          .html(data)
          .find('.insert-content-button').button().click(function() {
            var container_id = $('#content_container_id', dialog).val();
            var region = $('#content_region', dialog).val();
            var view = $('#breeze_view').val();
            $.ajax({
              url: $(this).attr('href'),
              type: 'post',
              dataType: 'script',
              data: 'container_id=' + container_id + '&region=' + region + '&view=' + view
            });
            return false;
          });
      });
      breeze._prepareEditorDialog(dialog);
      $('textarea, input[type=search]', dialog).eq(0).each(function() { this.focus(); });
    }
  });
  
  $('.breeze-form a[rel*=error]').live('click', function() {
    $((this.hash == '#page_permalink') ? '#page_slug' : this.hash, $(this).closest('form')).each(function() { this.focus(); });
    return false;
  });
  
  $.ui.marquess.commands['link'].fn = function(editor) {
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
      close: function() {
        $(this).remove();
      }
    });
    $('#marquess_link_text').val(editor.editor.selectedText()).each(function() { this.focus(); });
    $('#marquess_link_select').load('/admin/pages/list', function() {
      $('a', this).click(function() {
        if ($('#marquess_link_text').val() == '') { $('#marquess_link_text').val($(this).text()); }
        $('#marquess_link_url').val($(this).attr('href'));
        return false;
      });
      $('li.open, li.closed').click(function() {
        $(this).closest('li').toggleClass('open').toggleClass('closed');
        return false;
      });
    });
  };
})(jQuery);

// Cookies: http://stilbuero.de/jquery/cookie/
jQuery.cookie=function(name,value,options){if(typeof value!='undefined'){options=options||{};if(value===null){value='';options=$.extend({},options);options.expires=-1}var expires='';if(options.expires&&(typeof options.expires=='number'||options.expires.toUTCString)){var date;if(typeof options.expires=='number'){date=new Date();date.setTime(date.getTime()+(options.expires*24*60*60*1000))}else{date=options.expires}expires='; expires='+date.toUTCString()}var path=options.path?'; path='+(options.path):'';var domain=options.domain?'; domain='+(options.domain):'';var secure=options.secure?'; secure':'';document.cookie=[name,'=',encodeURIComponent(value),expires,path,domain,secure].join('')}else{var cookieValue=null;if(document.cookie&&document.cookie!=''){var cookies=document.cookie.split(';');for(var i=0;i<cookies.length;i++){var cookie=jQuery.trim(cookies[i]);if(cookie.substring(0,name.length+1)==(name+'=')){cookieValue=decodeURIComponent(cookie.substring(name.length+1));break}}}return cookieValue}};

// JSON
(function($){$.toJSON=function(o)
{if(typeof(JSON)=='object'&&JSON.stringify)
return JSON.stringify(o);var type=typeof(o);if(o===null)
return"null";if(type=="undefined")
return undefined;if(type=="number"||type=="boolean")
return o+"";if(type=="string")
return $.quoteString(o);if(type=='object')
{if(typeof o.toJSON=="function")
return $.toJSON(o.toJSON());if(o.constructor===Date)
{var month=o.getUTCMonth()+1;if(month<10)month='0'+month;var day=o.getUTCDate();if(day<10)day='0'+day;var year=o.getUTCFullYear();var hours=o.getUTCHours();if(hours<10)hours='0'+hours;var minutes=o.getUTCMinutes();if(minutes<10)minutes='0'+minutes;var seconds=o.getUTCSeconds();if(seconds<10)seconds='0'+seconds;var milli=o.getUTCMilliseconds();if(milli<100)milli='0'+milli;if(milli<10)milli='0'+milli;return'"'+year+'-'+month+'-'+day+'T'+
hours+':'+minutes+':'+seconds+'.'+milli+'Z"';}
if(o.constructor===Array)
{var ret=[];for(var i=0;i<o.length;i++)
ret.push($.toJSON(o[i])||"null");return"["+ret.join(",")+"]";}
var pairs=[];for(var k in o){var name;var type=typeof k;if(type=="number")
name='"'+k+'"';else if(type=="string")
name=$.quoteString(k);else
continue;if(typeof o[k]=="function")
continue;var val=$.toJSON(o[k]);pairs.push(name+":"+val);}
return"{"+pairs.join(", ")+"}";}};$.evalJSON=function(src)
{if(typeof(JSON)=='object'&&JSON.parse)
return JSON.parse(src);return eval("("+src+")");};$.secureEvalJSON=function(src)
{if(typeof(JSON)=='object'&&JSON.parse)
return JSON.parse(src);var filtered=src;filtered=filtered.replace(/\\["\\\/bfnrtu]/g,'@');filtered=filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']');filtered=filtered.replace(/(?:^|:|,)(?:\s*\[)+/g,'');if(/^[\],:{}\s]*$/.test(filtered))
return eval("("+src+")");else
throw new SyntaxError("Error parsing JSON, source is not valid.");};$.quoteString=function(string)
{if(string.match(_escapeable))
{return'"'+string.replace(_escapeable,function(a)
{var c=_meta[a];if(typeof c==='string')return c;c=a.charCodeAt();return'\\u00'+Math.floor(c/16).toString(16)+(c%16).toString(16);})+'"';}
return'"'+string+'"';};var _escapeable=/["\\\x00-\x1f\x7f-\x9f]/g;var _meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'};})(jQuery);

/**
* hoverIntent r5 // 2007.03.27 // jQuery 1.1.2+
* <http://cherne.net/brian/resources/jquery.hoverIntent.html>
* 
* @param  f  onMouseOver function || An object with configuration options
* @param  g  onMouseOut function  || Nothing (use configuration options object)
* @author    Brian Cherne <brian@cherne.net>
*/
(function($){$.fn.hoverIntent=function(f,g){var cfg={sensitivity:7,interval:100,timeout:0};cfg=$.extend(cfg,g?{over:f,out:g}:f);var cX,cY,pX,pY;var track=function(ev){cX=ev.pageX;cY=ev.pageY;};var compare=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);if((Math.abs(pX-cX)+Math.abs(pY-cY))<cfg.sensitivity){$(ob).unbind("mousemove",track);ob.hoverIntent_s=1;return cfg.over.apply(ob,[ev]);}else{pX=cX;pY=cY;ob.hoverIntent_t=setTimeout(function(){compare(ev,ob);},cfg.interval);}};var delay=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);ob.hoverIntent_s=0;return cfg.out.apply(ob,[ev]);};var handleHover=function(e){var p=(e.type=="mouseover"?e.fromElement:e.toElement)||e.relatedTarget;while(p&&p!=this){try{p=p.parentNode;}catch(e){p=this;}}if(p==this){return false;}var ev=jQuery.extend({},e);var ob=this;if(ob.hoverIntent_t){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);}if(e.type=="mouseover"){pX=ev.pageX;pY=ev.pageY;$(ob).bind("mousemove",track);if(ob.hoverIntent_s!=1){ob.hoverIntent_t=setTimeout(function(){compare(ev,ob);},cfg.interval);}}else{$(ob).unbind("mousemove",track);if(ob.hoverIntent_s==1){ob.hoverIntent_t=setTimeout(function(){delay(ev,ob);},cfg.timeout);}}};return this.mouseover(handleHover).mouseout(handleHover);};})(jQuery);