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
      this._buildToolbar();
      this._augmentRegions();
      this.editing(this.editing());
      
      $('body.breeze-editing .breeze-region-label>a.breeze-add-content').live('click', function() {
        breeze._openDialog('/admin/contents/new?content[container_id]=' + breeze.options.page_id + '&content[region]=' + $(this).closest('.breeze-editable-region').attr('data-region') + '&content[view]=' + breeze.options.view, {
          title: 'Add content',
          open: function() {
            $('.add-content-tabs', this).tabs();
            $(':input:visible', this).eq(0).each(function() { this.focus(); });
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
        $(this.toolbar)
          .toggleClass('top', position == 'top').toggleClass('bottom', position == 'bottom');
        $('#breeze-toolbar.top').css({ top:'0px', bottom:'auto' });
        $('#breeze-toolbar.bottom').css({ top:'auto', bottom:'0px' });

        return this.option('toolbar', position);
      } else return this.option('toolbar');
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
      
      $('<a href="#" class="breeze-toolbar-edit-button">Edit</a>')
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

      $('<a href="#" class="breeze-toolbar-position-button">Edit</a>')
        .appendTo(buttons)
        .click(function() {
          breeze.toolbarPosition(breeze.toolbarPosition() == 'top' ? 'bottom' : 'top');
          
          return false;
        });
    },
    _augmentRegions: function() {
      var breeze = this;
      $('.breeze-editable-region[id]').each(function() {
        $(this).attr('data-region', $(this).attr('id').replace(/_region$/, ''))
          .hoverIntent({
            over: function() { $(this).addClass('hover'); },
            out:  function() { $(this).removeClass('hover'); }
          });
        $('<div class="breeze-region-label"><strong>' + $(this).attr('data-region') + '</strong> <a href="#" class="breeze-add-content">+</a></div>')
          .appendTo(this);
      });
    },
    _openDialog: function(path, options) {
      if ($('#breeze-spinner').length == 0) { $('<div id="breeze-spinner" style="display: none;"></div>').appendTo('body'); }
      $('#breeze-spinner').fadeIn();
      
      $.get(path, function(data) {
        $('#breeze-spinner').fadeOut();
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
    }
  });
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