define ['MenuItem', 'jquery'], (MenuItem) -> 

  #TODO create menu & menuItem matchers, and strip equals function out of respective classes

  describe 'MenuItem', -> 

    describe 'constructor', -> 

      it 'adds a unique identifier field _uid', -> 
        obj = value: 'aValue', text: 'aText'
        item = new MenuItem obj
        item2 = new MenuItem obj

        hexRange = '[a-f0-9]'
        guidFormat = ///#{hexRange}{8}-#{hexRange}{4}-4#{hexRange}{3}-#{hexRange}{4}-#{hexRange}{12}///

        expect(item._uid.match(guidFormat)[0]).toEqual item._uid
        expect(item2._uid.match(guidFormat)[0]).toEqual item2._uid

        expect(item._uid).not.toEqual item2._uid
      
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

      it 'returns true if no clamp specified', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps()).toBe true

      it 'returns true if passes clamp', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(aClampProperty: 7)).toBe true

      it 'returns true if passes multi-clamp', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7], anotherClampProperty: [8]}
        expect(item.passesClamps(aClampProperty: 7, anotherClampProperty: 8)).toBe true

      it 'returns true if clamp specifies different property', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(anotherClampProperty: 7)).toBe true

      it 'returns false if does not pass clamps because of value', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7]}
        expect(item.passesClamps(aClampProperty: 8)).toBe false

      it 'returns false if does not pass single clamp of multi-clamp specification', ->
        item = new MenuItem value: 'aValue', text: 'someText', clamps: {aClampProperty: [7], anotherClampProperty: [9]}
        expect(item.passesClamps(aClampProperty: 7, anotherClampProperty: 8)).toBe false

