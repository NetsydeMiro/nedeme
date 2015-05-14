(function() {
  define(['MenuItem'], function(MenuItem) {
    var Menu;
    return Menu = (function() {
      function Menu(header, menuItemObjects) {
        var itemObject;
        this.header = header;
        this.items = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = menuItemObjects.length; _i < _len; _i++) {
            itemObject = menuItemObjects[_i];
            _results.push(new MenuItem(itemObject));
          }
          return _results;
        })();
      }

      return Menu;

    })();
  });

}).call(this);

//# sourceMappingURL=Menu.js.map
