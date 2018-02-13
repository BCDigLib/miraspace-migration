// Note: this script is for testing purposes only. 

var fs = require('fs');

var Mirador = {
  "id": "viewer",
  "mainMenuSettings": {
    "buttons": {
      "bookmark": false,
      "fullScreenViewer": false
    },
    "userLogo": {
      "label": "Boston College Library",
      "attributes": {
        "id": "bc-logo",
        "href": "https://library.bc.edu"
      }
    }
  },
  "data": [],
  "windowObjects": []
};

function readLines(input, func) {
  var remaining = '';

  input.on('data', function(data) {
    remaining += data;
    var index = remaining.indexOf('\n');
    while (index > -1) {
      var line = remaining.substring(0, index);
      remaining = remaining.substring(index + 1);
      func(line);
      index = remaining.indexOf('\n');
    }
  });

  input.on('end', function() {
    if (remaining.length > 0) {
      func(remaining);
    }
  });
}

function loadManifestData(data) {
  location = {
    "manifestUri": data,
    "location": "Boston College"
  };
  loaded = {
    "loadedManifest": data,
    "viewType": "ImageView"
  };
  Mirador["data"].push(location);
  Mirador["windowObjects"].push(loaded);
}

var input = fs.createReadStream('./manifests.txt');
readLines(input, loadManifestData);
console.log(Mirador);
