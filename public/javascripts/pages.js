$(function() {
  $('#left #pages').tree({
    ui: {
      theme_path: '/breeze/javascripts/jstree/themes/breeze/style.css',
      theme_name: 'breeze',
      dots: false,
      selected_parent_close: false
    },
    plugins: {
      contextmenu: {
        items: {
          create: {
						label	: "New…",
						icon	: "add_page",
						visible	: function(node, tree_obj) { if (node.length != 1) return 0; return tree_obj.check("creatable", node); }, 
						action	: function(node, tree_obj) {
						  var parent_id = $(node).attr('id').substring(5);
              $.get('/admin/pages/new?page[parent_id]=' + parent_id, function(data) {
                $('<div></div>').html(data).dialog({
                  title: 'New page',
                  modal: true,
                  resizable: false,
                  width: 480,
                  buttons: {
                    Cancel: function() {
                      $(this).dialog('close');
                    },
                    OK: function() {
                      $('#page_new:visible').trigger('submit');
                    }
                  },
                });
              });
						}
					},
					remove: {
					  action  : function(node, tree_obj) {
              $('<p>Are you sure you want to delete this page? There is no undo!</p>').dialog({
                modal: true,
                resizable: false,
                buttons: {
                  Delete: function() {
                    var id = $(node).attr('id').substring('5');
                    $(this).dialog('close');
                    close_tab(id);
                    $.ajax({
                      url: '/admin/pages/' + id + '.js',
                      type: 'post',
                      dataType: 'script',
                      data: '_method=delete'
                    });
                    $.each(node, function () { tree_obj.remove(this); });
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
      'root': {
        renameable: false,
        draggable: false,
        deletable: false
      },
      'page': {
        valid_children: [ 'page' ]
      }
    },
    rules: {
      multiple: false,
      drag_copy: false
    },
    callback: {
      onselect: function(node, tree) {
        a = $(node).children('a');
        id = $(node).attr('id').substring(5);
        url = '/admin/pages/' + id + '/edit';
        open_tab(id, url, {
          close:true,
          title:$(a).attr('title'),
          success: function(tab, pane) {
          }
        });
      },
      onmove: function(node, ref_node, type, tree_obj, rb) {
        $.ajax({
          url: '/admin/pages/' + $(node).attr('id').substring(5) + '/move.js',
          type: 'post',
          dataType: 'script',
          data: '_method=put&ref=' + $(ref_node).attr('id').substring(5) + '&type=' + type
        });
      },
      check_move: function(node, ref_node, type, tree_obj) {
        if ($(ref_node).closest('li').is('[rel=root]') && type == 'after') {
          return false;
        }
      }
    }
  });
  
  $.extend($.tree.reference('#left #pages'), {
    save: function() {
      this.__open_nodes = $.map($(this.container).find('li.open'), function(e, i) { return $(e).attr('id'); });
      this.__selected_nodes = $.map($(this.container).find('a.clicked'), function(e, i) { return $(e).parent().attr('id'); });
    },
    restore: function() {
      var self = this;
      $.each(this.__open_nodes, function(i, e) { self.open_branch($('#' + e), true); });
      $.each(this.__selected_nodes, function(i, e) { self.select_branch($('#' + e), true); });
    }
  });
});
