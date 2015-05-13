define ['MenuItem'], (MenuItem) -> 

  describe 'MenuItem', -> 

    describe '::isClamped()', -> 

      it 'returns true if clamped', ->
        item = new MenuItem 'aValue', 'someText', {aClampProperty: [7]}, {someData: null}
        expect(item.isClamped aClampProperty: 7).toBe true

      it 'returns false if not clamped', ->
        item = new MenuItem 'aValue', 'someText', {aClampProperty: [7]}, {someData: null}
        expect(item.isClamped aClampProperty: 8).toBe false

