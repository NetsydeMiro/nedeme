define ['MenuItem', 'Menu'], (MenuItem, Menu) -> 

  describe 'Menu', -> 

    describe 'constructor', -> 
      it 'constructs a menu from flat array of objects', -> 
        flatArray = [{value:1, text:'one'},{value:2, text:'two'},{value:3, text:'three'}]
        menu = new Menu 'MenuHeader', flatArray

        expect(menu.header).toEqual 'MenuHeader'
        expect(menu.items.length).toBe 3

        for arrayItem, arrayIndex in flatArray
          menuItem = menu.items[arrayIndex]
          expect(menuItem.constructor).toBe MenuItem
          expect(menuItem.value).toEqual arrayItem.value
          expect(menuItem.text).toEqual arrayItem.text

    describe '#clamp()', -> 

      it 'returns original menu if not clamped', ->
