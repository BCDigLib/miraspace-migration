/* Based on a gist by Johannes Baiter */

var DownloadButton = {
  /* the template for the image urls */
  imageUrlTemplate: Mirador.Handlebars.compile(
    '{{imageBaseUrl}}/full/{{size}}/0/default.jpg'
  ),

  /* the template for the link button */
  buttonTemplate: Mirador.Handlebars.compile([
    '<span class="mirador-btn mirador-icon-download" role="button" title="Download">',
    '{{#each imageUrls}}',
    '<span class="{{#if (eq this "#")}}disabled {{/if}}image-link">',
    '<a href="{{this.href}}" target="_blank">',
    '<i class="fa fa-download fa-lg fa-fwi"></i>',
    '</a>',
    '</span>',
    '{{/each}}',
    '</span>'
  ].join('')),

  /* extracts image urls from the viewer window */
  extractImageUrls: function(viewerWindow){
    var currentImage = viewerWindow.imagesList[viewerWindow.focusModules['ImageView'].currentImgIndex];
    var imageBaseUrl = Mirador.Iiif.getImageUrl(currentImage);
    var ratio = currentImage.height / currentImage.width;

    var imageUrls = [];
    ['full'].forEach(function(size){
      imageUrls.push({
        'href': viewerWindow.currentImageMode !== 'ImageView' ? '#' : this.imageUrlTemplate({
          'imageBaseUrl': imageBaseUrl, 'size': size
        }),
        'title': size === 'full' ? currentImage.width + 'x' + currentImage.height : parseInt(size) + 'x' + Math.ceil(parseInt(size) * ratio)
      });
    }.bind(this));
    return imageUrls;
  },

  /* initializes the plugin, i.e. adds an event handler */
  init: function(){
    Mirador.Handlebars.registerHelper('eq', function(first, second){
      return first === second;
    });
    this.injectWindowEventHandler();
    this.injectWorkspaceEventHandler();
  },

  /* injects the button to the window menu */
  injectButtonToMenu: function(windowButtons, manifestUrl, imageUrls){
    $(windowButtons).prepend(this.buttonTemplate({
      'imageUrls': imageUrls,
      'manifestUrl': manifestUrl,
    }));
  },

  /* injects the needed window event handler */
  injectWindowEventHandler: function(){
    var this_ = this;
    var origBindEvents = Mirador.Window.prototype.bindEvents;
    Mirador.Window.prototype.bindEvents = function(){
      origBindEvents.apply(this);
      this.eventEmitter.subscribe('windowUpdated', function(evt, data){
        if(this.id !== data.id || !data.viewType){
          return;
        }
        if(data.viewType === 'ImageView'){
          var imageUrls = this_.extractImageUrls(this);
          this.element.find('.image-link').removeClass('disabled').attr(
            'title', function(index){ return 'Download JPEG (' + imageUrls[index].title + ')'; }
          ).find('a').attr(
            'href', function(index){ return imageUrls[index].href; }
          ).find('span.dimensions').text(
            function(index){ return imageUrls[index].title; }
          );
        }else{
          this.element.find('.image-link').addClass('disabled');
        }
      }.bind(this));
    };
  },

  /* injects the needed workspace event handler */
  injectWorkspaceEventHandler: function(){
    var this_ = this;
    var origFunc = Mirador.Workspace.prototype.bindEvents;
    Mirador.Workspace.prototype.bindEvents = function(){
      origFunc.apply(this);
      this.eventEmitter.subscribe('windowAdded', function(evt, data){
        var viewerWindow = this.windows.filter(function(currentWindow){
          return currentWindow.id === data.id;
        })[0];
        var manifestUrl = viewerWindow.manifest.jsonLd['@id'];
        var canvases = viewerWindow.manifest.jsonLd.sequences[0].canvases;
        var imageUrls = this_.extractImageUrls(viewerWindow);
        var windowButtons = viewerWindow.element.find('.window-manifest-navigation');
        this_.injectButtonToMenu(windowButtons, manifestUrl, imageUrls);
      }.bind(this));
    };
  }
};

$(document).ready(function(){
  DownloadButton.init();
});
