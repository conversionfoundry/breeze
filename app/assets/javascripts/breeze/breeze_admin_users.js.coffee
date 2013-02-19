$ ->
  $(".new.user.button").click ->
    open_tab "new_user", "/admin/users/new",
      title: "New user"
      close: true
      success: (tab, pane) ->
        renumber_fields pane

    false

  $("#left #users a[data-user-id]").live "click", ->
    open_tab $(this).data("user-id"), $(this).attr("href"),
      title: $("strong", this).text()
      close: true

    false

  $("#left #users a[data-id=" + window.location.hash.substring(1) + "]").click()  if window.location.hash

$(".delete.delete-user").live "click", (e) ->
  e.preventDefault()
  delete_user_dialog( $(this).data('user-id') )

delete_user_dialog = (user_id) ->
  $("<p>Really delete this user? There is no undo!</p>").dialog
    title: "Confirm user delete"
    modal: true
    resizable: false
    show: "fade"
    buttons:
      Delete: ->
        $(this).dialog "close"
        $.ajax
          url: "/admin/users/" + user_id + ".js"
          type: "post"
          dataType: "html"
          data: "_method=delete"
          success: (result) ->
            eval result
          error: (result) ->
            eval result
      Cancel: ->
        $(this).dialog "close"
