$(document).ready ->
  if $('#left #pages').length > 0 # i.e. if we're on admin/pages
    $("#left #pages").tree
      ui:
        dots: false
        selected_parent_close: false

      plugins:
        contextmenu:
          items:
            create:
              label: "New…"
              icon: "add_page"
              visible: (node, tree_obj) ->
                return 0  unless node.length is 1
                tree_obj.check "creatable", node

              action: (node, tree_obj) ->
                parent_id = $(node).attr("id").substring(5)
                $.get "/admin/pages/new?page[parent_id]=" + parent_id, (data) ->
                  $("<div></div>").html(data).dialog
                    title: "New page"
                    modal: true
                    resizable: false
                    width: 480
                    buttons:
                      Cancel: ->
                        $(this).dialog "close"

                      OK: ->
                        $("#new_page:visible").trigger "submit"

                    close: ->
                      $(this).remove()

            remove:
              action: (node, tree_obj) ->
                $("<p>Really delete this page (and all its sub-pages)? There is no undo!</p>").dialog
                  title: "Confirm delete"
                  modal: true
                  resizable: false
                  buttons:
                    Delete: ->
                      id = $(node).attr("id").substring("5")
                      $(this).dialog "close"
                      close_tab id
                      $.ajax
                        url: "/admin/pages/" + id + ".js"
                        type: "post"
                        dataType: "script"
                        data: "_method=delete"

                      $.each node, ->
                        tree_obj.remove this


                    Cancel: ->
                      $(this).dialog "close"

                  close: ->
                    $(this).remove()

            duplicate:
              label: "Duplicate"
              icon: "duplicate_page"
              visible: (node, tree_obj) ->
                node.length is 1 and $(node).attr("rel") isnt "root"

              action: (node, tree_obj) ->
                id = $(node).attr("id").substring(5)
                $.ajax
                  url: "/admin/pages/" + id + "/duplicate.js"
                  type: "post"
                  dataType: "script"

      types:
        root:
          renameable: false
          draggable: false
          deletable: false

        page:
          valid_children: ["page"]

      rules:
        multiple: false
        drag_copy: false

      callback:
        onselect: (node, tree) ->
          a = $(node).children("a")
          id = $(node).attr("id").substring(5)
          url = "/admin/pages/" + id + "/edit"
          open_tab id, url,
            close: true
            title: $(a).attr("title")
            success: (tab, pane) ->


        onmove: (node, ref_node, type, tree_obj, rb) ->
          $.ajax
            url: "/admin/pages/" + $(node).attr("id").substring(5) + "/move.js"
            type: "post"
            dataType: "script"
            data: "_method=put&ref=" + $(ref_node).attr("id").substring(5) + "&type=" + type


        check_move: (node, ref_node, type, tree_obj) ->
          false  if $(ref_node).closest("li").is("[rel=root]") and type is "after"

    $.extend $.tree.reference("#left #pages"),
      save: ->
        @__open_nodes = $.map($(@container).find("li.open"), (e, i) ->
          $(e).attr "id"
        )
        @__selected_nodes = $.map($(@container).find("a.clicked"), (e, i) ->
          $(e).parent().attr "id"
        )

      restore: ->
        self = this
        $.each @__open_nodes, (i, e) ->
          self.open_branch $("#" + e), true

        $.each @__selected_nodes, (i, e) ->
          self.select_branch $("#" + e), true


    $("#new_page #page_title").live "input", ->
      slug_field = $("#page_slug", $(this).closest("form"))
      slug_field.val $(this).val().toLowerCase().replace(/[^a-z0-9\-\_]+/g, "-").replace(/(^\-+|\-+$)/g, "")  if slug_field.length > 0 and not slug_field[0].modified

    $("#new_page #page_slug").live "input", ->
      @modified = true

