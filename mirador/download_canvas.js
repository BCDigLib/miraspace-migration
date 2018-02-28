$(function() {
  var saveImage = function(e) {
    $('#dl-link').click(function(e) { 
      e.preventDefault();
      var slot = null;
      if (bcViewer.viewer.workspace.slots.length == 1) {
        slot = bcViewer.viewer.workspace.slots[0];
      } else {
        for (var sl = 0; sl < bcViewer.viewer.workspace.slots.length; sl++) {
          var slt = bcViewer.viewer.workspace.slots[sl];
          if (slt.slotID == slot_idx) {
            slot = bcViewer.viewer.workspace.slots[sl];
            break;
          }
        }
      }
      var mirWindow = slot.window;
      var uri = mirWindow.manifest.uri,
          parts = uri.split("/"),
          last_idx = parts.length - 1,
          img_id = mirWindow.focusModules.ImageView.currentImg["label"],
          focusType = mirWindow.currentImageMode;

      if (focusType !== "ImageView") {
        var $error = $('#error-modal');
        if ($error.get().length > 0) {
          $error.dialog('close');
        }
        $error = $('<div id="error-modal" style="display:none" />');
        $error.html(t['error-tmpl']({ op: "error", text: "The Save Image function is only available in single page viewing mode." }));
        $error.appendTo('body');
        $error.dialog($.extend({title: 'Function Unavailable'}, dialogBaseOpts)).dialog('open');
        return;
      }

      var canvas = document.getElementsByName("canvas")[0], ctx = canvas.getContext("2d");
      canvas.toBlob(function(blob) {
        saveAs(blob, `${img_id}.jpg`)
      });
    });
  }

  $(document).on('contextmenu', 'canvas', saveImage);
});