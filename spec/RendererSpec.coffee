define ['Renderer'], (Renderer) -> 

  describe 'Renderer', -> 

    describe '::fillTemplate', -> 

      it 'fills the template', ->
        template = "This is a {{value}} template"
        result = Renderer.fillTemplate template, {value: "test"}
        expect(result).toEqual "This is a test template"

      it 'fills multiple placeholders', ->
        template = "This is a {{value}} template. {{fin}}."
        result = Renderer.fillTemplate template, {value: "test", fin: 'Finito'}
        expect(result).toEqual "This is a test template. Finito."

      it 'collapses nested properties', -> 
        template = "This is a {{value}} template. Collapsed property: {{data-special}}. {{fin}}."
        result = Renderer.fillTemplate template, {value: "test", fin: 'Finito', data: {special: 'it works!'}}
        expect(result).toEqual "This is a test template. Collapsed property: it works!. Finito."

      it 'ignores specified properties', ->
        template = "This is a {{value}} template. This is ignored: {{ignored}}. {{fin}}."
        result = Renderer.fillTemplate template, {value: "test", fin: 'Finito', ignored: "this shouldn't render"}, ['ignored']
        expect(result).toEqual "This is a test template. This is ignored: {{ignored}}. Finito."


    describe '::createMarkup()', -> 


      it 'gets correct markup for empty menu', -> 

        markup = Renderer.createMarkup {header: 'AHeader', items: []}, 
        {menu: "<menu header='{{header}}'>{{items}}</menu>", 
        menuItem: "<menuitem text='{{text}}' value='{{value}}'></menuitem>"}

        expect(markup).toEqual "<menu header='AHeader'></menu>"

      it 'gets correct markup for flat menu', -> 

        expected = "<menu header='AHeader'>\
        <menuitem text='one' value='1'></menuitem>\
        <menuitem text='two' value='2'></menuitem>\
        </menu>"

        markup = Renderer.createMarkup {header: 'AHeader', items: [{text: 'one', value: 1},{text: 'two', value: 2}]}, 
        {menu: "<menu header='{{header}}'>{{items}}</menu>", 
        menuItem: "<menuitem text='{{text}}' value='{{value}}'></menuitem>"}

        expect(markup).toEqual expected

      it 'gets correct markup for nested menu', -> 

        expected = "<menu header='AHeader'>\
        <menuitem text='one' value='1'>\
        <menu header='BHeader'>\
        <menuitem text='oneone' value='11'></menuitem>\
        <menuitem text='onetwo' value='12'></menuitem>\
        </menu>\
        </menuitem>\
        <menuitem text='two' value='2'></menuitem>\
        </menu>"

        markup = Renderer.createMarkup({header: 'AHeader', items: 
          [
            {text: 'one', value: 1, subMenu: {header: 'BHeader', items: 
              [{text: 'oneone', value: 11}, {text: 'onetwo', value: 12}]}},
            {text: 'two', value: 2}
          ]}, 
        {menu: "<menu header='{{header}}'>{{items}}</menu>", 
        menuItem: "<menuitem text='{{text}}' value='{{value}}'>{{subMenu}}</menuitem>"})

        expect(markup).toEqual expected

      it 'allows overriding default markup', -> 

        expected = "<menu header='AHeader'>\
        <menuitem text='one' value='1'>\
        <submenu header='BHeader'>\
        <menuitem text='oneone' value='11'></menuitem>\
        <menuitem text='onetwo' value='12'></menuitem>\
        </submenu>\
        </menuitem>\
        <divider weird-here='true' />\
        <menuitem text='two' value='2'></menuitem>\
        </menu>"

        markup = Renderer.createMarkup({header: 'AHeader', items: 
          [
            {text: 'one', value: 1, subMenu: {header: 'BHeader', template: 'submenu', items: 
              [{text: 'oneone', value: 11}, {text: 'onetwo', value: 12}]}},
            {template: 'divider', weird: true},
            {text: 'two', value: 2}
          ]}, 
        {menu: "<menu header='{{header}}'>{{items}}</menu>", 
        submenu: "<submenu header='{{header}}'>{{items}}</submenu>", 
        divider: "<divider weird-here='{{weird}}' />",
        menuItem: "<menuitem text='{{text}}' value='{{value}}'>{{subMenu}}</menuitem>"})

        expect(markup).toEqual expected


      it 'calls supplied callback during markup creation', -> 

        spies = 
          onMarkupCreated: (obj, filledTemplate) -> filledTemplate

        spyOn(spies, 'onMarkupCreated').and.callThrough()

        menu = 
          header: 'AHeader' 
          items: [{text: 'one', value: 1},{text: 'two', value: 2}]

        templates = 
          menu: "<menu header='{{header}}'>{{items}}</menu>"
          menuItem: "<menuitem text='{{text}}' value='{{value}}'></menuitem>"

        markup = Renderer.createMarkup menu, templates, spies.onMarkupCreated

        expect(spies.onMarkupCreated.calls.count()).toEqual 3

        expect(spies.onMarkupCreated.calls.argsFor(0)).toEqual [menu.items[0], "<menuitem text='one' value='1'></menuitem>"]
        expect(spies.onMarkupCreated.calls.argsFor(1)).toEqual [menu.items[1], "<menuitem text='two' value='2'></menuitem>"]
        expect(spies.onMarkupCreated.calls.argsFor(2)).toEqual [menu, "<menu header='AHeader'>\
        <menuitem text='one' value='1'></menuitem>\
        <menuitem text='two' value='2'></menuitem>\
        </menu>"]

      it 'calls supplied callback during nested markup creation', -> 

        spies = 
          onMarkupCreated: (obj, filledTemplate) -> filledTemplate

        spyOn(spies, 'onMarkupCreated').and.callThrough()

        menu = 
          header: 'AHeader' 
          items: 
            [
              {
                text: 'one' 
                value: 1 
                subMenu: 
                  header: 'BHeader' 
                  items: 
                    [
                      {text: 'oneone', value: 11} 
                      {text: 'onetwo', value: 12}
                    ]
              }
              {
                text: 'two' 
                value: 2
              }
            ]

        templates = 
          menu: "<menu header='{{header}}'>{{items}}</menu>"
          menuItem: "<menuitem text='{{text}}' value='{{value}}'>{{subMenu}}</menuitem>"

        markup = Renderer.createMarkup menu, templates, spies.onMarkupCreated

        expect(spies.onMarkupCreated.calls.count()).toEqual 6

        expect(spies.onMarkupCreated.calls.argsFor(0)).toEqual [
          menu.items[0].subMenu.items[0]
          "<menuitem text='oneone' value='11'></menuitem>"
        ]

        expect(spies.onMarkupCreated.calls.argsFor(1)).toEqual [
          menu.items[0].subMenu.items[1]
          "<menuitem text='onetwo' value='12'></menuitem>"
        ]

        expect(spies.onMarkupCreated.calls.argsFor(2)).toEqual [
          menu.items[0].subMenu 
          "<menu header='BHeader'>\
          <menuitem text='oneone' value='11'></menuitem>\
          <menuitem text='onetwo' value='12'></menuitem>\
          </menu>"
        ]

        expect(spies.onMarkupCreated.calls.argsFor(3)).toEqual [
          menu.items[0] 
          "<menuitem text='one' value='1'>\
          <menu header='BHeader'>\
          <menuitem text='oneone' value='11'></menuitem>\
          <menuitem text='onetwo' value='12'></menuitem>\
          </menu>\
          </menuitem>"
        ]

        expect(spies.onMarkupCreated.calls.argsFor(4)).toEqual [
          menu.items[1] 
          "<menuitem text='two' value='2'></menuitem>"
        ]

        expect(spies.onMarkupCreated.calls.argsFor(5)).toEqual [
          menu 
          "<menu header='AHeader'>\
          <menuitem text='one' value='1'>\
          <menu header='BHeader'>\
          <menuitem text='oneone' value='11'></menuitem>\
          <menuitem text='onetwo' value='12'></menuitem>\
          </menu>\
          </menuitem>\
          <menuitem text='two' value='2'></menuitem>\
          </menu>"
        ]


      it 'supplied callback can modify final markup', -> 

        onMarkupCreated = (obj, filledTemplate) -> 
          filledTemplate.replace('header', 'footer').replace('text', 'word')

        menu = 
          header: 'AHeader' 
          items: [{text: 'one', value: 1},{text: 'two', value: 2}]

        templates = 
          menu: "<menu header='{{header}}'>{{items}}</menu>"
          menuItem: "<menuitem text='{{text}}' value='{{value}}'></menuitem>"

        markup = Renderer.createMarkup menu, templates, onMarkupCreated

        expected = "<menu footer='AHeader'>\
        <menuitem word='one' value='1'></menuitem>\
        <menuitem word='two' value='2'></menuitem>\
        </menu>"

        expect(markup).toEqual expected


      it 'supplied callback can modify source object', -> 

        onMarkupCreated = (obj, filledTemplate) -> 
          obj.newProperty = obj
          filledTemplate

        menu = 
          header: 'AHeader' 
          items: [{text: 'one', value: 1},{text: 'two', value: 2}]

        templates = 
          menu: "<menu header='{{header}}'>{{items}}</menu>"
          menuItem: "<menuitem text='{{text}}' value='{{value}}'></menuitem>"

        markup = Renderer.createMarkup menu, templates, onMarkupCreated

        expect(menu.newProperty).toBe menu
        expect(menu.items[0].newProperty).toBe menu.items[0]
        expect(menu.items[1].newProperty).toBe menu.items[1]

