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


    describe '::addAttributes()', ->

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


    describe '::ancestorBranch()', -> 

      it 'returns list with just itself if there is no parent property', -> 
        item = {test: 'test'}
        branch = Utility.ancestorBranch.call item

        expect(branch).toEqual [item]

      it 'returns list with just itself if there is a nulled parent property ', -> 
        item = {test: 'test', parent: null}
        branch = Utility.ancestorBranch.call item

        expect(branch).toEqual [item]

      it 'returns list with itself and parent if there is a parent specified', -> 
        item = {test: 'test', parent: {test: 'parent'}}
        branch = Utility.ancestorBranch.call item

        expect(branch).toEqual [item.parent, item]

      it 'returns expected branch when working up a hierarchy', -> 
        root = {item: 'root'}
        root.children = []
        root.children.push {item: 'child1', parent: root}
        root.children.push child2 = {item: 'child2', parent: root}
        child2.children = []
        child2.children.push {item: 'grandchild1'}
        child2.children.push grandchild = {item: 'grandchild2', parent: child2}
        child2.children.push {item: 'grandchild3'}

        branch = Utility.ancestorBranch.call grandchild

        expect(branch).toEqual [root, child2, grandchild]

