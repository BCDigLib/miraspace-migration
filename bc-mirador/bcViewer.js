/* mdObj refers to an object declared in the corresponding HTML file that 
defines various viewer attributes for a given resource */
var l = window.mdObj;
var bcViewer = Mirador({
  "id": "viewer",
  "mainMenuSettings": {
    "buttons": {
      "bookmark": false,
      "fullScreenViewer": false,
      "layout": false
    },
    "userButtons": l.MIRADOR_BUTTONS,
    "userLogo": {
      "label": "Boston College Library",
      "attributes": {
        "id": "bc-logo",
        "href": "https://library.bc.edu",
        "target": "_blank"
      }
    }
  },
  "data": l.MIRADOR_DATA,
  "windowObjects": l.MIRADOR_WOBJECTS
});

var mobileMenu = setTimeout(function(){
  $('.user-buttons').slicknav({
    label: 'Menu',
    prependTo: '.mirador-main-menu-bar'
  });
}, 100);
