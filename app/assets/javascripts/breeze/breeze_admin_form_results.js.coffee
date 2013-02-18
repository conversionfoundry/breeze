$(".delete.delete-form_result").live "click", (e) ->
  e.preventDefault()
  delete_form_result_dialog( $(this).data('form-result-id') )

delete_form_result_dialog = (form_result_id) ->
  $("<p>Really delete this form_result? There is no undo!</p>").dialog
    title: "Confirm form result delete"
    modal: true
    resizable: false
    show: "fade"
    buttons:
      Delete: ->
        $(this).dialog "close"
        $.ajax
          url: "/admin/form_results/" + form_result_id + ".js"
          type: "post"
          dataType: "html"
          data: "_method=delete"
          success: (result) ->
            eval result
          error: (result) ->
            eval result
      Cancel: ->
        $(this).dialog "close"
