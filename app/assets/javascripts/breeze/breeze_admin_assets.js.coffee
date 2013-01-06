$(document).ready ->
  if $('#left #folders').length > 0 # i.e. if we're on admin/pages
    show_or_hide_asset_section_headings();

    $("#left #folders").jstree
      core : {  },
      plugins : [ "crrm", "ui", "html_data", "contextmenu" ],
      ui:
        select_limit: 1
        dots: false
      contextmenu:
        items:
          ccp: false
          create: false
          create: false
            # action: (node) ->
            #   $("#left #folders").jstree("create",node)
          rename: false
            # action: (node) ->
            #   $("#left #folders").jstree("rename",node)
          remove: false
            # action: (node) ->
            #   message = $(this).attr("data-confirm") or "Are you sure you want to delete this?"
            #   $("<p>" + message + "</p>").dialog
            #     modal: true
            #     resizable: false
            #     buttons:
            #       Delete: ->
            #         $(this).dialog "close"
            #         $.each node, ->
            #           $("#left #folders").jstree("remove", node)
            #       Cancel: ->
            #         $(this).dialog "close"
            #     title: "Confirm delete"
      types:
        default:
          deletable: true
          renameable: true
          create: true
        special:
          rename: false
          deletable: false
          start_drag: false
          move_node: false
        file:
          create: false
          valid_children: []
        folder:
          valid_children: ["file", "folder"]
      rules:
        multiple: false
        drag_copy: false
    .bind 'rename.jstree', (node, ref) ->
      url = $(">a", ref.rslt.obj[0]).attr("href")
      name = ref.rslt.new_name
      rename_file url, name
    .bind 'remove.jstree', (node, ref) ->
      url = $(">a", ref.rslt.obj[0]).attr("href")
      remove_file url 
    .bind 'create.jstree', (node, ref) ->
      parent = ref.rslt.parent[0]
      node = ref.rslt.obj[0]
      name = ref.rslt.name
      create_file parent, node, name

$("#left #folders a").live "click", (e) ->
  a = $(this)
  url = $(a).attr("href")
  unless url is ""
    folder = $(a).closest('li').attr('data-folder');
    $('#right #uploader').uploadifySettings('folder', folder)
    $('#assets')
      .fadeTo('normal', 0.5)
      .load url, ->
        show_or_hide_asset_section_headings()
        $(this).fadeTo('normal', 1.0)
        $('.asset', this).makeDraggable()


# remove_file = (url) ->
#   $.ajax
#     url: url
#     type: "post"
#     data: "_method=delete"

# rename_file = (url, name) ->
#   unless url is ""
#     $.ajax
#       url: url
#       data: "_method=put&" + ((if $(node).hasClass("folder") then "folder" else "file")) + "[name]=" + escape(name)
#       type: "post"

# create_file = (parent, node, name) ->
#   parent_href = $(">a", parent).attr("href")
#   if /\.\w+$/.test(name)
#     # create a file
#     parent_href = parent_href.replace(/^\/admin\/themes\/([^\/]+)\/folders/, "/admin/themes/$1/files")
#     path = parent_href + "/" + file_name
#     $.ajax
#       url: path
#       type: "post"
#       data: "_method=put"
#       success: ->
#         $(">a", node).attr("href", path).click().parent().addClass name.replace(/^.*\.([^\.]+)$/, "$1")
#   else
#     # create a folder
#     $(node).addClass "folder"
#     folder_name = name
#     $.ajax
#       url: parent_href
#       type: "post"
#       data: "folder[name]=" + folder_name
#       success: ->
#         $(">a", node).attr("href", parent_href + "/" + folder_name).click()

