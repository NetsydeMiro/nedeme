(function() {
  define(['MenuItem', 'Menu'], function(MenuItem, Menu) {
    return describe('Menu', function() {
      describe('constructor', function() {
        return it('constructs a menu from flat array of objects', function() {
          var arrayIndex, arrayItem, flatArray, menu, menuItem, _i, _len, _results;
          flatArray = [
            {
              value: 1,
              text: 'one'
            }, {
              value: 2,
              text: 'two'
            }, {
              value: 3,
              text: 'three'
            }
          ];
          menu = new Menu('MenuHeader', flatArray);
          expect(menu.header).toEqual('MenuHeader');
          expect(menu.items.length).toBe(3);
          _results = [];
          for (arrayIndex = _i = 0, _len = flatArray.length; _i < _len; arrayIndex = ++_i) {
            arrayItem = flatArray[arrayIndex];
            menuItem = menu.items[arrayIndex];
            expect(menuItem.constructor).toBe(MenuItem);
            expect(menuItem.value).toEqual(arrayItem.value);
            _results.push(expect(menuItem.text).toEqual(arrayItem.text));
          }
          return _results;
        });
      });
      return describe('#clamp()', function() {
        return it('returns original menu if not clamped', function() {});
      });
    });
  });

}).call(this);

//# sourceMappingURL=MenuSpec.js.map
