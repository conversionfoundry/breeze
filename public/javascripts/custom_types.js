$(function() {
  $('#right .new.custom_type.button').click(function() {
    open_tab('new_custom_type', '/admin/custom_types/new', {
      title: 'New custom type',
      close: true,
      success: function(tab, pane) {
        renumber_fields(pane);
      }
    });
    return false;
  });
  
  $('.add-field').live('click', function() {
    var button = this;
    $.get('/admin/custom_types/new_field', function(data) {
      $(button).before(data);
      renumber_fields($(button).closest('form'));
    });
  });
  
  $('select.custom-field-type').live('change', function() {
    var field = $(this).closest('.custom-field');
    var name = $('input[name$=\[name\]]', field).val();
    var label = $('input[name$=\[label\]]', field).val();
    var form = $(this).closest('form');
    $.get('/admin/custom_types/new_field', { 'custom_field[label]':label, 'custom_field[name]':name, 'custom_field[_type]':$(this).val() }, function(data) {
      $(field).replaceWith(data);
      renumber_fields(form);
    });
  });
});

function renumber_fields(container) {
  $('.custom-field', container).each(function(i) {
    $('label', this).each(function() {
      $(this).attr('for', $(this).attr('for').replace(/^custom_type_custom_fields_attributes_[0-9]+/, 'custom_type_custom_fields_attributes_' + i));
    });
    $('input, select, textarea', this).each(function() {
      $(this).attr('id', $(this).attr('id').replace(/^custom_type_custom_fields_attributes_[0-9]+/, 'custom_type_custom_fields_attributes_' + i));
      $(this).attr('name', $(this).attr('name').replace(/^custom_type\[custom_fields_attributes\]\[[0-9]+/, 'custom_type[custom_fields_attributes][' + i));
    });
  });
  
  $('.custom-field .delete', container).toggle($('.custom-field', container).length > 1);
}