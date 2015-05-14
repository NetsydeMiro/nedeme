define ['MenuItem'], (MenuItem) -> 

  describe 'MenuItem', -> 

    describe '#isClamped()', -> 

      it 'returns true if clamped', ->
        item = new MenuItem 'aValue', 'someText', {aClampProperty: [7]}
        expect(item.isClamped(aClampProperty: 7)).toBe true

      it 'returns false if not clamped by value', ->
        item = new MenuItem 'aValue', 'someText', {aClampProperty: [7]}
        expect(item.isClamped(aClampProperty: 8)).toBe false

      it 'returns false if not clamped by property', ->
        item = new MenuItem 'aValue', 'someText', {aClampProperty: [7]}
        expect(item.isClamped(anotherClampProperty: 7)).toBe false

