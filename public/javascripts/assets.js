(function($) {
  $(function() {
    $('.asset a[rel=edit]').live('click', function() {
      var asset = $(this).closest('.asset');
      if (asset.hasClass('image')) {
        $.get(this.href, function(data) {
          $('<div></div>').html(data).appendTo('body').dialog({
            title: 'Edit image',
            modal: true,
            resizable: false,
            width: 752,
            height: 522,
            buttons: {
              Cancel: function() {
                $(this).dialog('close');
              },
              OK: function() {
                $('form:visible', $(this).closest('.ui-dialog')).trigger('submit');
              }
            },
            open: function() {
              var dialog = this, api;
              $(this).css({ position: 'relative' });
              var refreshControls = function(coords) {
                coords = api.tellSelect();
                var has_selection = coords && coords.w > 0 && coords.h > 0;
                if (has_selection) {
                  $('#asset_crop_selection_width', dialog).val(coords.w);
                  $('#asset_crop_selection_height', dialog).val(coords.h);
                  $('#asset_crop_selection_x', dialog).val(coords.x);
                  $('#asset_crop_selection_y', dialog).val(coords.y);
                  $('.image-selection', dialog).show();
                } else {
                  $('.image-selection', dialog).hide();
                }
                
                var cropping = $('#asset_crop_resize:checked', dialog).length > 0;
                $('div.image-crop', dialog).toggle(cropping);
                
                if (cropping) {
                  var crop_mode = $('div.image-crop ul input:checked', dialog).val();
                  var target_width = parseInt($('#asset_crop_target_width').val() || 0);
                  var target_height = parseInt($('#asset_crop_target_height').val() || 0);
                  
                  if (crop_mode == 'resize_to_fit') {
                    var source_width = has_selection ? coords.w : parseInt($('#asset_image_width').val());
                    var source_height = has_selection ? coords.h : parseInt($('#asset_image_height').val());
                    var scale = Math.min(target_width / source_width, target_height / source_height);
                    $('#asset_crop_final_width', dialog).val(Math.round(source_width * scale));
                    $('#asset_crop_final_height', dialog).val(Math.round(source_height * scale));
                  } else {
                    $('#asset_crop_final_width', dialog).val(target_width);
                    $('#asset_crop_final_height', dialog).val(target_height);
                  }
                } else if (has_selection) {
                  $('#asset_crop_final_width', dialog).val(coords.w);
                  $('#asset_crop_final_height', dialog).val(coords.h);
                } else {
                  
                }
              };
              api = $.Jcrop('.image-preview img', {
                boxWidth: 512,
                boxHeight: 440,
                onChange: refreshControls,
                onSelect: refreshControls
              });
              $('#asset_crop_resize, input[type=radio]', dialog).click(refreshControls);
              $('input[type=text]', dialog).bind('input', refreshControls);
              $('div.image-crop :input').change(function() {
                var cropping = $('#asset_crop_resize:checked', dialog).length > 0;
                if (cropping) {
                  var crop_mode = $('div.image-crop ul input:checked', dialog).val();
                  var target_width = parseInt($('#asset_crop_target_width').val() || 0);
                  var target_height = parseInt($('#asset_crop_target_height').val() || 0);

                  api.setOptions({ aspectRatio: crop_mode == 'force' ? target_width / target_height : 0 });
                }
                refreshControls();
              }).bind('input', function() { $(this).change(); });
              refreshControls();
            },
            close: function() {
              $(this).remove();
            }
          });
        });
      }
      
      return false;
    });
  });
})(jQuery);