(function() {
  define(['MenuItem'], function(MenuItem) {
    return describe('MenuItem', function() {
      return describe('::isClamped()', function() {
        it('returns true if clamped', function() {
          var item;
          item = new MenuItem('aValue', 'someText', {
            aClampProperty: [7]
          }, {
            someData: null
          });
          return expect(item.isClamped({
            aClampProperty: 7
          })).toBe(true);
        });
        return it('returns false if not clamped', function() {
          var item;
          item = new MenuItem('aValue', 'someText', {
            aClampProperty: [7]
          }, {
            someData: null
          });
          return expect(item.isClamped({
            aClampProperty: 8
          })).toBe(false);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=MenuItemSpec.js.map
