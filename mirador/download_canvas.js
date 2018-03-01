/* mdObj refers to an object declared in the corresponding HTML file that 
defines various viewer attributes for a given resource */
var l = window.mdObj;
var bcViewer = Mirador({
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

$(document).on('click', '#dl-link', function() {
  var slot = null;
  if (bcViewer.viewer.workspace.slots.length == 1) {
    slot = bcViewer.viewer.workspace.slots[0];
  } else {
    // TODO: handle multiple slots
  }
  var mirWindow = slot.window;
  var imgId = mirWindow.focusModules.ImageView.currentImg["label"],
      canvasUriBase = 'http://scenery.bc.edu/',
      canvasUriSuffix = '/full/full/0/default.jpg',
      canvasUri = canvasUriBase + imgId + '.jp2' + canvasUriSuffix;
  var a = document.getElementById("dl-link");
  a.href = canvasUri;
});

window.addEventListener('contextmenu', function (e) { // Not compatible with IE < 9
  e.preventDefault();
}, false);