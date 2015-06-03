define ['Utility', 'jquery'], (Utility) ->

  #TODO create guid id matcher

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


    describe 'addAttributes', ->

      it 'adds an attribute', -> 
        markup = '<div></div>'
        result = Utility.addAttributes markup, {attrname: 'attrValue'}

        expect(result).toEqual '<div attrname="attrValue"></div>'

      it 'downcases attribute names', -> 
        markup = '<div></div>'
        result = Utility.addAttributes markup, {hungarianCaseName: 'attrValue'}

        expect(result).toEqual '<div hungariancasename="attrValue"></div>'

      it 'can add multiple attributes', -> 
        markup = '<div></div>'
        result = Utility.addAttributes markup, {attrname: 'attrValue', attrname2: 'attrValue2'}

        expect(result).toEqual '<div attrname="attrValue" attrname2="attrValue2"></div>'
