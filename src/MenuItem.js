(function() {
  define(function() {
    var MenuItem;
    return MenuItem = (function() {
      function MenuItem(value, text, clamps, data) {
        this.value = value;
        this.text = text;
        this.clamps = clamps;
        this.data = data;
      }

      MenuItem.prototype.isClamped = function(selections) {
        var property, value, _i, _len;
        for (value = _i = 0, _len = selections.length; _i < _len; value = ++_i) {
          property = selections[value];
          if (this.clamps[property] === value) {
            return true;
          }
        }
      };

      return MenuItem;

    })();
  });

}).call(this);

//# sourceMappingURL=MenuItem.js.map
