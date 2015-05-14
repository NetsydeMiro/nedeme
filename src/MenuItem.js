(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(function() {
    var MenuItem;
    return MenuItem = (function() {
      function MenuItem(value, text, clamps, subMenu, data) {
        this.value = value;
        this.text = text;
        this.clamps = clamps != null ? clamps : {};
        this.subMenu = subMenu != null ? subMenu : [];
        this.data = data != null ? data : null;
        if (this.value === Object(this.value)) {
          this.load(this.value);
        }
      }

      MenuItem.prototype.isClamped = function(selections) {
        var property, value;
        for (property in selections) {
          value = selections[property];
          if (__indexOf.call(this.clamps[property], value) >= 0) {
            return true;
          }
        }
        return false;
      };

      MenuItem.prototype.load = function(obj) {
        var _ref;
        this.value = obj.value;
        this.text = obj.text;
        this.clamps = (_ref = obj.clamps) != null ? _ref : {};
        this.subMenu = obj.subMenu || [];
        return this.data = obj.data;
      };

      return MenuItem;

    })();
  });

}).call(this);

//# sourceMappingURL=MenuItem.js.map
