// Check if client browser is Chrome
function isChrome() {
  var isChromium = window.chrome,
    winNav = window.navigator,
    vendorName = winNav.vendor,
    isOpera = winNav.userAgent.indexOf("OPR") > -1,
    isIEedge = winNav.userAgent.indexOf("Edge") > -1,
    isIOSChrome = winNav.userAgent.match("CriOS");

  if (isIOSChrome) {
    return true;
  } else if (
    isChromium !== null &&
    typeof isChromium !== "undefined" &&
    vendorName === "Google Inc." &&
    isOpera === false &&
    isIEedge === false
  ) {
    return true;
  } else { 
    return false;
  }
}


/* Sends an XHR to Loris to load the current canvas as a blob and updates the 
 * "Download Current Image" link to point to it in a download attribute 
 */
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

$(document).ready(function() {
  // New XHR when the window loads, so users don't have to click the link twice
  $(window).load(function() {
    xhrProcessor();
  });
  // New XHR whenever we click a thumbnail
  $(document).on("click", ".highlight", function() {
    xhrProcessor();
  });
  /* New XHR whenever we click a link on the sidebar
   * Note: event propagation the .toc-link class must be enabled (see line 39671 
   * in mirador.js)
   */
  $(document).on("click", ".toc-link", function() {
    xhrProcessor();
  });
});

// Disable right-click context menu
window.addEventListener('contextmenu', function(e) { // Not compatible with IE < 9
  e.preventDefault();
}, false);
