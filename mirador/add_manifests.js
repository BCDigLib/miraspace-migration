/*
Note: this script is for testing purposes only. It might not be
necessary in production, since we wouldn't link users directly
to the Mirador landing page that lists all the objects.
*/

var fs = require('fs');

var Mirador = {
  id: "viewer",
  data: []
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

function func(data) {
  location = {
    manifestUri: data,
    location: "Boston College"
  };
  Mirador['data'].push(location);
}

var input = fs.createReadStream('./manifests.txt');
readLines(input, func);
console.log(Mirador);
