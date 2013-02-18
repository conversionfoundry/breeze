
renumber_fields = (container) ->
  $(".custom-field", container).each (i) ->
    $("label", this).each ->
      $(this).attr "for", $(this).attr("for").replace(/^custom_type_custom_fields_attributes_[0-9]+/, "custom_type_custom_fields_attributes_" + i)

    $("input, select, textarea", this).each ->
      $(this).attr "id", $(this).attr("id").replace(/^custom_type_custom_fields_attributes_[0-9]+/, "custom_type_custom_fields_attributes_" + i)
      $(this).attr "name", $(this).attr("name").replace(/^custom_type\[custom_fields_attributes\]\[[0-9]+/, "custom_type[custom_fields_attributes][" + i)


  $(".custom-fields", container).each ->
    $(this).sortable (if $(this).hasClass("ui-sortable") then "refresh" else
      items: ">.custom-field"
      update: ->
        renumber_fields container
    )

$ ->
  $("#left #custom-types a").live "click", ->
    open_tab $(this).attr("data-id"), @href,
      title: $("strong", this).text()
      close: true
      success: (tab, pane) ->
        renumber_fields pane

    false

  $("#right .new.custom_type.button").click ->
    open_tab "new_custom_type", "/admin/custom_types/new",
      title: "New custom type"
      close: true
      success: (tab, pane) ->
        renumber_fields pane

    false

  $(".add-field").live "click", ->
    button = this
    $.get "/admin/custom_types/new_field", (data) ->
      $(button).prev("fieldset").append data
      renumber_fields $(button).closest("form")

    false

  $(".custom-field a.delete").live "click", ->
    field = $(this).closest(".custom-field")
    # Store deleted field – deletion will be committed when custom type is saved.
    if (hidden_id_field = $("input[name$=\"[id]\"]", field)).length > 0
      i = $("input.deleted-field").length + 1
      $(field).after "<input type=\"hidden\" class=\"deleted-field\" name=\"custom_type[custom_fields_attributes][-" + i + "][id]\" value=\"" + hidden_id_field.val() + "\" /><input type=\"hidden\" name=\"custom_type[custom_fields_attributes][-" + i + "][_destroy]\" value=\"1\" />"
    $(field).remove()
    renumber_fields field.closest(".custom-fields")
    false

  $("select.custom-field-type").live "change", ->
    field = $(this).closest(".custom-field")
    name = $("input[name$=[name]]", field).val()
    label = $("input[name$=[label]]", field).val()
    form = $(this).closest("form")
    $.get "/admin/custom_types/new_field",
      "custom_field[label]": label
      "custom_field[name]": name
      "custom_field[_type]": $(this).val()
    , (data) ->
      $(field).replaceWith data
      renumber_fields form

$(".delete.delete-custom_type").live "click", (e) ->
  e.preventDefault()
  delete_custom_type_dialog( $(this).data('custom-type-id') )

delete_custom_type_dialog = (custom_type_id) ->
  $("<p>Really delete this custom_type? There is no undo!</p>").dialog
    title: "Confirm custom type delete"
    modal: true
    resizable: false
    show: "fade"
    buttons:
      Delete: ->
        $(this).dialog "close"
        $.ajax
          url: "/admin/custom_types/" + custom_type_id + ".js"
          type: "post"
          dataType: "html"
          data: "_method=delete"
          success: (result) ->
            eval result
          error: (result) ->
            eval result
      Cancel: ->
        $(this).dialog "close"

