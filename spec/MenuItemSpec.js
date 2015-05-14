(function() {
  define(['MenuItem'], function(MenuItem) {
    return describe('MenuItem', function() {
      return describe('#isClamped()', function() {
        it('returns true if clamped', function() {
          var item;
          item = new MenuItem('aValue', 'someText', {
            aClampProperty: [7]
          });
          return expect(item.isClamped({
            aClampProperty: 7
          })).toBe(true);
        });
        it('returns false if not clamped by value', function() {
          var item;
          item = new MenuItem('aValue', 'someText', {
            aClampProperty: [7]
          });
          return expect(item.isClamped({
            aClampProperty: 8
          })).toBe(false);
        });
        return it('returns false if not clamped by property', function() {
          var item;
          item = new MenuItem('aValue', 'someText', {
            aClampProperty: [7]
          });
          return expect(item.isClamped({
            anotherClampProperty: 7
          })).toBe(false);
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=MenuItemSpec.js.map
