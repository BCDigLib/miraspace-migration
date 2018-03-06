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

function xhrProcessor() {
  if (bcViewer.viewer.workspace.slots.length == 1) {
    var slot = bcViewer.viewer.workspace.slots[0];
  } else {
    // TODO: handle multiple slots
  }
  var mirWindow = slot.window;
  var imgId = mirWindow.focusModules.ImageView.currentImg["label"],
      canvasUriBase = 'http://scenery.bc.edu/',
      canvasUriSuffix = '/full/full/0/default.jpg',
      canvasUri = canvasUriBase + imgId + '.jp2' + canvasUriSuffix,
      filename = imgId + '.jpg';

  var xhr = new XMLHttpRequest(),
        a = document.getElementById("dl-link"), file;
  xhr.open('GET', canvasUri, true);
  xhr.responseType = 'blob';
  xhr.onload = function(e) {
      file = new Blob([xhr.response], { type : 'application/octet-stream' });
      a.href = window.URL.createObjectURL(file);
      a.download = filename;
      a.click;
  };
  xhr.send();
}

$(document).on("click", xhrProcessor);

window.addEventListener('contextmenu', function(e) { // Not compatible with IE < 9
  e.preventDefault();
}, false);