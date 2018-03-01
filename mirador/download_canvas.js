var bcViewer;
$(function() {
  /* mdObj refers to an object declared in the corresponding HTML file that 
  defines various viewer attributes for a given resource */
  var l = window.mdObj;

  bcViewer = Mirador({
    "id": "viewer",
    "mainMenuSettings": {
      "buttons": {
        "bookmark": false,
        "fullScreenViewer": false
      },
      "userButtons": l.MIRADOR_BUTTONS,
      "userLogo": {
        "label": "Boston College Library",
        "attributes": {
          "id": "bc-logo",
          "href": "https://library.bc.edu"
        }
      }
    },
    "data": l.MIRADOR_DATA,
    "windowObjects": l.MIRADOR_WOBJECTS
  });

  // Largely borrowed from Harvard. Needs retooling.
  $('#dl-link').click(function(e) { 
    e.preventDefault();
    var slot = null;
    if (bcViewer.viewer.workspace.slots.length == 1) {
      slot = bcViewer.viewer.workspace.slots[0];
    } else {
      // TODO: handle multiple slots
    }
    var mirWindow = slot.window;
    var imgId = mirWindow.focusModules.ImageView.currentImg["label"],
        focusType = mirWindow.currentImageMode,
        canvasUriBase = 'https://scenery.bc.edu/',
        canvasUriSuffix = '/full/full/0/default.jpg',
        canvasUri = canvasUriBase + imgId + '.jp2' + canvasUriSuffix;

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

    /*
    canvasUri.toBlob(function(blob) {
      saveAs(blob, `${img_id}.jpg`)
    });
    */
  });

  /*
  window.addEventListener('contextmenu', function (e) { // Not compatible with IE < 9
    e.preventDefault();
  }, false);
  */
});