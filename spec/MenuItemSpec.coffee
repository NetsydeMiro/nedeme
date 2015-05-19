define ['MenuItem'], (MenuItem) -> 

  describe 'MenuItem', -> 

    describe '#equals', -> 

      it 'returns truthy if specific properties are same ', -> 
        obj = value: 'aValue', text: 'aText'
        item = new MenuItem obj
        expect(item == obj).toBe false
        expect(item.equals obj).toBeTruthy()

      it 'returns falsy if value is different', -> 
        obj = value: 'aValue', text: 'aText'
        item = new MenuItem obj
        obj.value = 'bValue'
        expect(item.equals obj).toBeFalsy()

      it 'returns falsy if text is different', -> 
        obj = value: 'aValue', text: 'aText'
        item = new MenuItem obj
        obj.text = 'bText'
        expect(item.equals obj).toBeFalsy()

      it "executes provided constructor's equal function to determine subMenu equality", -> 
        menuConstructor = (obj) -> 
          @header = obj.header
          @items = obj.items
          return this

        menuConstructor::equals = jasmine.createSpy('equals').and.returnValue(false)

        obj = value: 'aValue', text: 'aText', subMenu: {header: 'subMenu', items: [{value: 'aValue', text: 'aText'}] }
        item = new MenuItem obj, menuConstructor
        expect(item.equals obj).toBeFalsy()
        expect(menuConstructor::equals).toHaveBeenCalled()

    describe '#passesClamps()', -> 

      it 'returns true if passes clamps', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(aClampProperty: 7)).toBe true

      it 'returns false if does not pass clamps because of value', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(aClampProperty: 8)).toBe false

      it 'returns false if does not pass clamps becaus of property', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(anotherClampProperty: 7)).toBe false

