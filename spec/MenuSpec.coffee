define ['MenuItem', 'Menu'], (MenuItem, Menu) -> 

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


      it 'adds a unique identifier field _uid', -> 
        obj = {header: 'MenuHeader', items: [{value:1, text:'one'},{value:2, text:'two'},{value:3, text:'three'}]}
        menu = new Menu obj
        menu2 = new Menu obj

        hexRange = '[a-f0-9]'
        guidFormat = ///#{hexRange}{8}-#{hexRange}{4}-4#{hexRange}{3}-#{hexRange}{4}-#{hexRange}{12}///

        expect(menu._uid.match(guidFormat)[0]).toEqual menu._uid
        expect(menu2._uid.match(guidFormat)[0]).toEqual menu2._uid

        expect(menu._uid).not.toEqual menu2._uid


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

    describe '#find()', -> 
      nestedMenu = null

      beforeEach -> 

        nestedMenu = new Menu(
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
        )

      it 'returns null for missing element', -> 
        expect(nestedMenu.find('nonsenseuid')).toBeNull()

      it 'finds the menu', -> 
        expect(nestedMenu.find(nestedMenu._uid)).toBe nestedMenu

      it 'finds a menuItem', -> 
        expect(nestedMenu.find(nestedMenu.items[1]._uid)).toBe nestedMenu.items[1]

      it 'finds a nested menu', -> 
        expect(nestedMenu.find(nestedMenu.items[0].subMenu._uid)).toBe nestedMenu.items[0].subMenu

      it 'finds a nested menu item', -> 
        expect(nestedMenu.find(nestedMenu.items[0].subMenu.items[0]._uid)).toBe nestedMenu.items[0].subMenu.items[0]


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

