define ['Utility', 'jquery'], (Utility) ->

  describe 'Utility', -> 
    describe '::guid', -> 

      it 'creates a string', -> 
        expect($.type Utility.guid()).toEqual 'string'

      it 'creates a new string each time', -> 
        expect(Utility.guid()).not.toEqual Utility.guid()

      it 'creates a string with guid-like format', -> 
        hexRange = '[a-f0-9]'
        guidFormat = ///#{hexRange}{8}-#{hexRange}{4}-4#{hexRange}{3}-#{hexRange}{4}-#{hexRange}{12}///
        guid = Utility.guid()

        expect(guid.match(guidFormat)[0]).toEqual guid

