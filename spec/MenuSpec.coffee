define ['MenuItem', 'Menu'], (MenuItem, Menu) -> 

  menuItemEquals = (m1, m2) -> 
    m1 and m2 and m1.value == m2.value and m1.text == m2.text and 
      (not m1.subMenu and not m2.subMenu or menuItemEquals(m1.subMenu, m2.subMenu))

  describe 'Menu', -> 

    describe 'constructor', -> 
      it 'constructs a flat menu from object', -> 
        flatObject = {header: 'MenuHeader', items: [{value:1, text:'one'},{value:2, text:'two'},{value:3, text:'three'}]}
        menu = new Menu flatObject
        expect(menu.equals flatObject).toBeTruthy()

      it 'constructs a nested menu from object', -> 
        nestedObject =
          {
            header: 'MenuHeader'
            items: 
              [
                {
                  value:1 
                  text:'one' 
                  subMenu: 
                    header: 'nested' 
                    items: 
                      [
                        {
                          value:11
                          text:'oneone'
                        }
                      ]
                },
                {
                  value:2 
                  text:'two'
                }
              ]
          }

        menu = new Menu nestedObject

        expect(menu.equals nestedObject).toBeTruthy()


    describe '#equals()', -> 

      it 'returns truthy if specific properties are same ', -> 
        obj = header: 'aMenu', items: [{text: 'aText', value: 'aValue'}, {text: 'bText', value: 'bValue'}]
        menu = new Menu obj
        expect(menu == obj).toBe false
        expect(menu.equals obj).toBeTruthy()

      it 'returns falsy if header is different', -> 
        obj = header: 'aMenu', items: [{text: 'aText', value: 'aValue'}, {text: 'bText', value: 'bValue'}]
        menu = new Menu obj
        obj.header = 'changedMenu'
        expect(menu.equals obj).toBeFalsy()

      it 'returns falsy if different number of menu items', -> 
        obj = header: 'aMenu', items: [{text: 'aText', value: 'aValue'}, {text: 'bText', value: 'bValue'}]
        menu = new Menu obj
        obj.items.push {text: 'cText', value: 'cValue'}
        expect(menu.equals obj).toBeFalsy()

      it 'returns falsy if different menu items', -> 
        obj = header: 'aMenu', items: [{text: 'aText', value: 'aValue'}, {text: 'bText', value: 'bValue'}]
        menu = new Menu obj
        obj.items[0].text = 'newText'
        expect(menu.equals obj).toBeFalsy()


    describe '#clamped()', -> 

      it 'returns original menu if not clamped', ->

        nestedObject =
          {
            header: 'MenuHeader'
            items: 
              [
                {
                  value:1 
                  text:'one' 
                  clamps: {aClamp: [1]}
                  subMenu: 
                    header: 'nested' 
                    items: 
                      [
                        {
                          value:11
                          text:'oneone'
                          clamps: {aClamp: [1]}
                        },
                        {
                          value:12
                          text:'onetwo'
                          clamps: {aClamp: [1]}
                        },
                      ]
                },
                {
                  value:2 
                  text:'two'
                  clamps: {aClamp: [1]}
                }
              ]
          }

        menu = new Menu nestedObject

        clampedMenu = menu.clamped()
        
        expect(clampedMenu.equals nestedObject).toBeTruthy()


      it 'returns original menu if clamps pass', ->

        nestedObject =
          {
            header: 'MenuHeader'
            items: 
              [
                {
                  value:1 
                  text:'one' 
                  clamps: {aClamp: [1]}
                  subMenu: 
                    header: 'nested' 
                    items: 
                      [
                        {
                          value:11
                          text:'oneone'
                          clamps: {aClamp: [1]}
                        },
                        {
                          value:12
                          text:'onetwo'
                          clamps: {aClamp: [1]}
                        },
                      ]
                },
                {
                  value:2 
                  text:'two'
                  clamps: {aClamp: [1]}
                }
              ]
          }

        menu = new Menu nestedObject

        clampedMenu = menu.clamped(aClamp: 1)

        expect(clampedMenu.equals nestedObject).toBeTruthy()

