define ['MenuItem', 'Menu'], (MenuItem, Menu) -> 

  menuItemEquals = (m1, m2) -> 
    m1 and m2 and m1.value == m2.value and m1.text == m2.text and 
      (m1.subMenu == null and m2.subMenu == null or menuItemEquals(m1.subMenu, m2.subMenu))

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
          expect(menuItemEquals menuItem, arrayItem).toBeTruthy

      it 'constructs a nested menu from array of objects', -> 
        nestedArray =
          [
            {
              value:1 
              text:'one' 
              subMenu: 
                header: 'nested' 
                items: 
                  value:11
                  text:'oneone'
            },
            {
              value:2 
              text:'two'
            }
          ]

        menu = new Menu 'MenuHeader', nestedArray

        expect(menu.header).toEqual 'MenuHeader'
        expect(menu.items.length).toBe 2

        for arrayItem, arrayIndex in nestedArray 
          menuItem = menu.items[arrayIndex]
          expect(menuItem.constructor).toBe MenuItem

          expect(menuItemEquals menuItem, arrayItem).toBeTruthy


    describe '#clamp()', -> 

      it 'returns original menu if not clamped', ->
