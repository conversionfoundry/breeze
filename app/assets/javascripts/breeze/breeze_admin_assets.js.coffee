$(document).ready ->

  # jQuery File Upload Widget:
  $("#fileupload").fileupload
    xhrFields:
      withCredentials: true
    dropZone: $("#dropzone")
    done: (e, data) ->
      eval data.result
      show_or_hide_asset_section_headings()
    progressall: (e, data) ->
      progress = parseInt(data.loaded / data.total * 100, 10)
      $("#progress .bar").css "width", progress + "%"

  # Drag and drop files
  $(document).bind "dragover", (e) ->
    dropZone = $("#dropzone")
    timeout = window.dropZoneTimeout
    unless timeout
      dropZone.addClass "in"
    else
      clearTimeout timeout
    if e.target is dropZone[0]
      dropZone.addClass "hover"
    else
      dropZone.removeClass "hover"
    window.dropZoneTimeout = setTimeout(->
      window.dropZoneTimeout = null
      dropZone.removeClass "in hover"
    , 100)

  $(document).bind "drop dragover", (e) ->
    e.preventDefault()

  #  File tree
  if $('#left #folders').length > 0 # i.e. if we're on admin/assets
    
    show_or_hide_asset_section_headings()

    $("#left #folders").jstree
      core : 
        initially_open : [ $('#left #folders ul:first-child li')[0].id ]
      plugins : [ "crrm", "ui", "html_data", "contextmenu" ],
      ui:
        select_limit: 1
        dots: false
        initially_select : [ "/" ]

      contextmenu:
        items:
          ccp: false
          create:
            label: "New Folder…"
            icon: "add_folder"
            action: (node, tree_obj) ->
              parent_folder = $(node).data("folder")
              open_new_folder_dialog(parent_folder)
          remove:
           label: "Delete Folder…"
           action: (node, tree_obj) ->
              folder = encodeURIComponent( $(node).data("folder") )
              delete_asset_folder_dialog(folder)
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
        # drag_copy: false
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
    folder = $(a).closest('li').attr('id')
    show_asset_folder(folder)

show_asset_folder = (folder) ->
  url = '/admin/assets/folders/' + encodeURIComponent( folder )
  $('.file_upload #content_asset_folder').val(folder) # Tell the upload form which folder to use
  $('#assets')
    .fadeTo('normal', 0.5)
    .load url, ->
      show_or_hide_asset_section_headings()
      $(this).fadeTo('normal', 1.0)

$(".new.asset_folder.button").live "click", (e) ->
  if $('#folders li a.jstree-clicked').length > 0
    parent_folder = $('#pages li a.jstree-clicked').closest('li').id
  else
    parent_folder = $('#pages ul:first-child li')[0].id
  open_new_folder_dialog(parent_folder)
  false

$(".delete.asset_folder.button").live "click", (e) ->
  e.preventDefault()
  folder = encodeURIComponent( $(this).data('folder') )
  delete_asset_folder_dialog( folder )

$(".delete.delete-asset").live "click", (e) ->
  e.preventDefault()
  delete_asset_dialog( $(this).data('asset-id') )

open_new_folder_dialog = (parent_folder) ->
  $.get "/admin/assets/folders/new?folder[parent_folder]=" + parent_folder, (data) ->
    $("<div></div>").html(data).dialog
      title: "New asset folder"
      modal: true
      resizable: false
      width: 480
      show: "fade",
      buttons:
        Cancel: ->
          $(this).dialog "close"
        OK: ->
          $("#new_asset_folder:visible").trigger "submit"
      close: ->
        $(this).remove()

delete_asset_dialog = (asset_id) ->
  $("<p>Really delete this asset? There is no undo!</p>").dialog
    title: "Confirm asset delete"
    modal: true
    resizable: false
    show: "fade"
    buttons:
      Delete: ->
        $(this).dialog "close"
        $.ajax
          url: "/admin/assets/" + asset_id + ".js"
          type: "post"
          dataType: "html"
          data: "_method=delete"
          success: (result) ->
            eval result
          error: (result) ->
            eval result
      Cancel: ->
        $(this).dialog "close"

delete_asset_folder_dialog = (folder) ->
  $("<p>Really delete this folder (and all its contents)? There is no undo!</p>").dialog
    title: "Confirm folder delete"
    modal: true
    resizable: false
    show: "fade"
    buttons:
      Delete: ->
        $(this).dialog "close"
        $.ajax
          url: "/admin/assets/folders/" + folder + ".js"
          type: "post"
          dataType: "html"
          data: "_method=delete"
          success: (result) ->
            eval result
          error: (result) ->
            eval result
      Cancel: ->
        $(this).dialog "close"

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

show_or_hide_asset_section_headings = ->
  $("#assets .assets").each ->
    $(this).prev("h3").toggle $(".asset", this).length > 0