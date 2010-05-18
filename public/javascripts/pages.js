$(function() {
  $('#left #pages').tree({
    ui: {
      theme_path: '/breeze/javascripts/jstree/themes/breeze/style.css',
      theme_name: 'breeze',
      dots: false
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
      onmove: function(move_object) {
        // TODO: implement!
      }
    }
  });
})