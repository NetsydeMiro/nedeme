define ['Nedeme', 'jquery-ui'], (Nedeme) -> 

  describe 'Nedeme Internals', -> 

    describe '#_addMarkupUid()', -> 

      it 'adds data-nedemeuid property', -> 
        nedeme = new Nedeme

        result = nedeme._addMarkupUid({_uid: 'test'}, '<span></span>')

        expect(result).toEqual '<span data-nedemeuid="test"></span>'


    describe '#_mapClamps()', -> 

      menus = null

      beforeEach -> 

        menus = 
          one: {items: [{text: 'oneone', value: 11}, {text: 'onetwo', value: 12}]} 
          two: {items: [{text: 'twoone', value: 21}, {text: 'twotwo', value: 22}]} 

      it 'gets text property by default', -> 

        nedeme = new Nedeme menus
        nedeme.selected = one: menus.one.items[0], two: menus.two.items[1]

        result = nedeme._mapClamps()

        expect(result).toEqual {one: 'oneone', two: 'twotwo'}

      it 'returns null for menu without selection', ->

        nedeme = new Nedeme menus
        nedeme.selected = two: menus.two.items[1]

        result = nedeme._mapClamps()

        expect(result).toEqual {one: null, two: 'twotwo'}

      it 'can be overidden by supplying a mapping function', ->

        nedeme = new Nedeme menus, {mapClamp: (menuName, selectedItem) -> selectedItem and selectedItem.value or 'missing' }
        nedeme.selected = two: menus.two.items[1]

        result = nedeme._mapClamps()

        expect(result).toEqual {one: 'missing', two: 22}

