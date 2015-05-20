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


    describe '::getMarkup()', -> 

      it 'gets correct markup for empty menu', -> 

        markup = Renderer.getMarkup({header: 'AHeader', items: []}, 
        "<menu header='{{header}}'>{{items}}</menu>", 
        "<menuitem text='{{text}}' value='{{value}}'></menuitem>")

        expect(markup).toEqual "<menu header='AHeader'></menu>"

      it 'gets correct markup for flat menu', -> 

        expected = "<menu header='AHeader'>\
        <menuitem text='one' value='1'></menuitem>\
        <menuitem text='two' value='2'></menuitem>\
        </menu>"

        markup = Renderer.getMarkup({header: 'AHeader', items: [{text: 'one', value: 1},{text: 'two', value: 2}]}, 
        "<menu header='{{header}}'>{{items}}</menu>", 
        "<menuitem text='{{text}}' value='{{value}}'></menuitem>")

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

        markup = Renderer.getMarkup({header: 'AHeader', items: 
          [
            {text: 'one', value: 1, subMenu: {header: 'BHeader', items: 
              [{text: 'oneone', value: 11}, {text: 'onetwo', value: 12}]}},
            {text: 'two', value: 2}
          ]}, 
        "<menu header='{{header}}'>{{items}}</menu>", 
        "<menuitem text='{{text}}' value='{{value}}'>{{subMenu}}</menuitem>")

        expect(markup).toEqual expected


