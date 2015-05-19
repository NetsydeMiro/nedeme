define ['Renderer'], (Renderer) -> 

  describe 'Renderer', -> 

    describe '::fillTemplate', -> 

      it 'fills the template', ->
        template = "This is a {{value}} template"
        result = Renderer.fillTemplate template, {value: "test"}
        expect(result).toEqual "This is a test template"

      it 'removes unknown placeholders', ->
        template = "This is a {{value}} template"
        result = Renderer.fillTemplate template, {value2: "not entered"}
        expect(result).toEqual "This is a  template"

      it 'fills multiple placeholders', ->
        template = "This is a {{value}} template. {{fin}}."
        result = Renderer.fillTemplate template, {value: "test", fin: 'Finito'}
        expect(result).toEqual "This is a test template. Finito."

    describe '::getMarkup()', -> 

      it 'gets correct markup for empty menu', -> 

        markup = Renderer.getMarkup({header: 'AHeader', items: []}, 
        "<menu header='{{header}}'>{{items}}</menu>", 
        "<menuitem text='{{text}}' value='{{value}}'></menuitem>")

        expect(markup).toEqual "<menu header='AHeader'></menu>"

      xit 'gets correct markup for flat menu', -> 

        markup = Renderer.getMarkup({header: 'AHeader', items: [{text: 'one', value: 1},{text: 'two', value: 2}]}, 
        "<menu header='{{header}}'>{{items}}</menu>", 
        "<menuitem text='{{text}}' value='{{value}}'></menuitem>")

        expect(markup).toEqual "<menu header='AHeader'>
        <menuitem text='one' value='1'></menuitem>
        <menuitem text='two' value='2'></menuitem>
        </menu>"

