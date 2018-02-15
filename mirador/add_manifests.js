var fs = require('fs');
var pretty = require('pretty');

function buildDocument(miradorObj, identifier) {
  var doc = pretty('<!DOCTYPE html>'
       + '<html>' + '<head>' + '<title>' + identifier + '</title>'
       + '<meta charset="UTF-8">' + '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
       + '<link rel="stylesheet" type="text/css" href="build/mirador/css/mirador-combined.css">'
       + '<link rel="stylesheet" type="text/css" href="build/mirador/css/mirador-bc.css">'
       + '<script src="build/mirador/mirador.js"></script>' + '</head>' + '<body>'
       + '<div id="viewer"></div>' + '<script type="text/javascript">'
       + '$(function() { Mirador(' + miradorObj + '); });' + '</script>' + '</body>' + '</html>');

  fs.writeFile(identifier, doc, (err) => {
    if (err) throw err;
    console.log(`Saved ${identifier} to file`);
  });
}

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
  var mirador = {
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
  var location = {
    "manifestUri": data,
    "location": "Boston College"
  };
  var loaded = {
    "loadedManifest": data,
    "viewType": "ImageView"
  };

  mirador["data"].push(location);
  mirador["windowObjects"].push(loaded);

  var identifier = data.split('/').pop().slice(0, -5);
  var miradorObj = JSON.stringify(mirador);

  buildDocument(miradorObj, identifier);
}

var input = fs.createReadStream('./manifests.txt');
readLines(input, loadManifestData);
