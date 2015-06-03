define ['Nedeme', 'jquery-ui'], (Nedeme) -> 

  # TODO: create markup without id matcher
  stripMarkupIds = (markup) -> 
    hexRange = '[a-f0-9]'
    guidFormat = "#{hexRange}{8}-#{hexRange}{4}-4#{hexRange}{3}-#{hexRange}{4}-#{hexRange}{12}"
    result = markup.replace ///\sdata-nedemeuid="#{guidFormat}"///g, ''
    result

  # from http://stackoverflow.com/questions/3442394/jquery-using-text-to-retrieve-only-text-not-nested-in-child-tags
  textAndOnlyText = ($element) -> 
    $element.contents().filter( -> @nodeType is 3 )[0].nodeValue

  describe 'Nedeme', -> 

    $testTarget = null

    beforeEach => 
      $testTarget = $ '<div id="test-target"></div>'
      $('body').append $testTarget

    afterEach -> 
      $testTarget.remove()

    describe '#renderMenu()', -> 

      basicMenus = null

      beforeEach -> 
        basicMenus = 
          menuOne: 
            items: [
              {
                text: 'A1' 
                subMenu: 
                  items: [
                    {text: 'B1'}
                    {text: 'B2'}
                  ]
              }
              {text: 'A2'}
            ]
          menuTwo:
            items: [
              {
                text: 'C1', 
                subMenu:
                  items: [
                    {text: 'D1'}
                    {text: 'D2'}
                  ]
              }
              {text: 'C2'}
            ]

      it 'renders default menus', -> 

        nedeme = new Nedeme basicMenus, {activate: -> }

        $menu1 = $('<div id="menu1"></div>').appendTo $testTarget
        $menu2 = $('<div id="menu2"></div>').appendTo $testTarget

        nedeme.renderMenu 'menuOne', '#menu1'
        nedeme.renderMenu 'menuTwo', '#menu2'

        expected1 = "
        <ul>\
        <li>A1\
        <ul>\
        <li>B1</li>\
        <li>B2</li>\
        </ul>\
        </li>\
        <li>A2</li>\
        </ul>\
        "

        expected2 = "
        <ul>\
        <li>C1\
        <ul>\
        <li>D1</li>\
        <li>D2</li>\
        </ul>\
        </li>\
        <li>C2</li>\
        </ul>\
        "

        expect(stripMarkupIds $menu1.html()).toEqual expected1
        expect(stripMarkupIds $menu2.html()).toEqual expected2

      it 'clears existing content prior to rendering', -> 

        nedeme = new Nedeme basicMenus, {activate: -> }

        $menu1 = $('<div id="menu1">Dummy Content</div>').appendTo $testTarget
        $menu2 = $('<div id="menu2">Should Disappear</div>').appendTo $testTarget

        nedeme.renderMenu 'menuOne', '#menu1'
        nedeme.renderMenu 'menuTwo', '#menu2'

        expected1 = "
        <ul>\
        <li>A1\
        <ul>\
        <li>B1</li>\
        <li>B2</li>\
        </ul>\
        </li>\
        <li>A2</li>\
        </ul>\
        "

        expected2 = "
        <ul>\
        <li>C1\
        <ul>\
        <li>D1</li>\
        <li>D2</li>\
        </ul>\
        </li>\
        <li>C2</li>\
        </ul>\
        "

        expect(stripMarkupIds $menu1.html()).toEqual expected1
        expect(stripMarkupIds $menu2.html()).toEqual expected2


      it 'tags markup with appropriate ids', -> 

        nedeme = new Nedeme {menuOne: basicMenus.menuOne}, {activate: -> }

        $menuContainer = $('<div id="menu1">Dummy Content</div>').appendTo $testTarget

        markup = nedeme.renderMenu 'menuOne', '#menu1'

        menuOne = nedeme.menus.menuOne

        $menu = $menuContainer.find('ul').first()
        expect($menu.data('nedemeuid')).toEqual menuOne._uid

        $subMenu = $menuContainer.find('li ul').first()
        expect($subMenu.data('nedemeuid')).toEqual menuOne.items[0].subMenu._uid

        $items = $menuContainer.find('li')

        expect($($items[0]).data('nedemeuid')).toEqual menuOne.items[0]._uid
        expect($($items[1]).data('nedemeuid')).toEqual menuOne.items[0].subMenu.items[0]._uid
        expect($($items[2]).data('nedemeuid')).toEqual menuOne.items[0].subMenu.items[1]._uid
        expect($($items[3]).data('nedemeuid')).toEqual menuOne.items[1]._uid


      describe 'selected', -> 
        
        nedeme = $menuContainerOne = $menuContainerTwo = $menuWidgetOne = $menuWidgetTwo = null

        beforeEach -> 
          nedeme = new Nedeme basicMenus

          $menuContainerOne = $('<div id="menu1"></div>').appendTo $testTarget
          $menuContainerTwo = $('<div id="menu2"></div>').appendTo $testTarget

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

        it 'is empty by default', -> 
          expect(nedeme.selected).toEqual {}

        it 'can be initialized', -> 
          nedeme = new Nedeme basicMenus, {selected: {menuOne: 'test'}}

          $menuContainerOne = $('<div id="menu1"></div>').appendTo $testTarget
          $menuContainerTwo = $('<div id="menu2"></div>').appendTo $testTarget

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

          expect(nedeme.selected).toEqual {menuOne: 'test'}

        it 'is altered during a menu select', -> 
          $listItem = $menuContainerOne.find('ul li').first()
          
          # select a list item
          $menuWidgetOne.menu('focus', null, $listItem)
          $menuWidgetOne.menu('select')

          expect(nedeme.selected.menuOne.equals basicMenus.menuOne.items[0]).toBe true

          $listItem = $menuContainerOne.find('ul li').last()
          
          # select another list item
          $menuWidgetOne = nedeme.menuWidgets.menuOne
          $menuWidgetOne.menu('focus', null, $listItem)
          $menuWidgetOne.menu('select')

          expect(nedeme.selected.menuOne.equals basicMenus.menuOne.items[1]).toBe true

        it 'can set a selection per mens.u', -> 
          $listItem = $menuContainerOne.find('ul li').first()
          
          # select a list item
          $menuWidgetOne.menu('focus', null, $listItem)
          $menuWidgetOne.menu('select')

          expect(nedeme.selected.menuOne.equals basicMenus.menuOne.items[0]).toBe true

          $listItem = $menuContainerTwo.find('ul li').last()
          
          # select a list item in anothe menu
          $menuWidgetTwo = nedeme.menuWidgets.menuTwo
          $menuWidgetTwo.menu('focus', null, $listItem)
          $menuWidgetTwo.menu('select')

          expect(nedeme.selected.menuTwo.equals basicMenus.menuTwo.items[1]).toBe true

      describe 'clamping', -> 

        nedeme = clampedMenus = $menuContainerOne = $menuContainer2 = null

        beforeEach -> 
          clampedMenus = 
            menuOne: 
              items: [
                {
                  text: 'A1' 
                  subMenu: 
                    items: [
                      {text: 'B1'}
                      {text: 'B2'}
                    ]
                }
                {text: 'A2', clamps: {menuTwo: ['C2']}}
              ]
            menuTwo:
              items: [
                {
                  text: 'C1', 
                  clamps: {menuOne: ['A2']}
                  subMenu:
                    items: [
                      {text: 'D1'}
                      {text: 'D2'}
                    ]
                }
                {text: 'C2'}
              ]

          $menuContainerOne = $('<div id="menu1"></div>').appendTo $testTarget
          $menuContainerTwo = $('<div id="menu2"></div>').appendTo $testTarget


        it 'clamps menus on initial render due to default (none) selections', -> 
          nedeme = new Nedeme(clampedMenus)

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

          expect($menuWidgetOne.children('li').length).toBe 1
          expect(textAndOnlyText($menuWidgetOne.children('li'))).toEqual 'A1'
          expect($menuWidgetTwo.children('li').length).toBe 1
          expect($menuWidgetTwo.children('li').text()).toEqual 'C2'

        it 'does not clamp menus on initial render if appropriate selection is provided', -> 
          nedeme = new Nedeme clampedMenus
          nedeme.selected = menuOne: nedeme.menus.menuOne.items[1]

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

          expect($menuWidgetOne.children('li').length).toBe 1
          expect(textAndOnlyText($menuWidgetOne.children('li'))).toEqual 'A1'
          expect($menuWidgetTwo.children('li').length).toBe 2

        it 'clamps menu if appropriate selection made', -> 
          nedeme = new Nedeme clampedMenus
          nedeme.selected = menuOne: nedeme.menus.menuOne.items[1], menuTwo: nedeme.menus.menuTwo.items[1]

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

          expect($menuWidgetOne.children('li').length).toBe 2
          expect($menuWidgetTwo.children('li').length).toBe 2

          # clamp menu two
          $listItem = $menuWidgetOne.children('li').first()
          $menuWidgetTwo.menu('focus', null, $listItem)
          $menuWidgetTwo.menu('select')

          $menuWidgetTwo = nedeme.menuWidgets.menuTwo

          expect($menuWidgetOne.children('li').length).toBe 2
          expect($menuWidgetTwo.children('li').length).toBe 1
          expect($menuWidgetTwo.children('li').text()).toEqual 'C2'


        it 'unclamps menu if appropriate selection made', -> 
          nedeme = new Nedeme(clampedMenus)

          $menuWidgetOne = nedeme.renderMenu 'menuOne', '#menu1'
          $menuWidgetTwo = nedeme.renderMenu 'menuTwo', '#menu2'

          # unclamp menu one
          $listItem = $menuWidgetTwo.children('li')
          $menuWidgetTwo.menu('focus', null, $listItem)
          $menuWidgetTwo.menu('select')

          $menuWidgetOne = nedeme.menuWidgets['menuOne']

          expect($menuWidgetOne.children('li').length).toBe 2
          expect($menuWidgetTwo.children('li').length).toBe 1

          # unclamp menu two
          $listItem = $menuWidgetOne.children('li').last()
          $menuWidgetOne.menu('focus', null, $listItem)
          $menuWidgetOne.menu('select')

          $menuWidgetTwo = nedeme.menuWidgets['menuTwo']

          expect($menuWidgetOne.children('li').length).toBe 2
          expect($menuWidgetTwo.children('li').length).toBe 2


      describe 'select event', -> 

        onSelect = menuOne = nedeme = $menuContainer = $menuWidget = $listItem = call = null

        beforeEach -> 
          onSelect = jasmine.createSpy('onSelect')

          menuOne = basicMenus.menuOne
          nedeme = new Nedeme {menuOne: menuOne}, select: onSelect

          $menuContainer = $('<div id="menu1"></div>').appendTo $testTarget

          $menuWidget = nedeme.renderMenu 'menuOne', '#menu1'

          $listItem = $menuContainer.find('ul li').first()
          
          # select a list item
          $menuWidget.menu('focus', null, $listItem)

        it 'fires supplied callback function', -> 
          $menuWidget.menu('select')
          call = onSelect.calls.mostRecent()

          expect(onSelect.calls.count()).toEqual 1

        describe 'callback function', -> 

          it 'this argument is menu dom', -> 
            $menuWidget.menu('select')
            call = onSelect.calls.mostRecent()

            expect(call.object).toBe $menuWidget[0]

          it 'first argument should be the original event', -> 
            $menuWidget.menu('select')
            call = onSelect.calls.mostRecent()

            #TODO: find better test to check for jquery event here
            expect(call.args[0].type).toEqual 'menuselect' 

          it 'second argument should be selected menu item dom', -> 
            $menuWidget.menu('select')
            call = onSelect.calls.mostRecent()

            expect(call.args[1]).toBe $listItem[0]

          it 'third argument should be selected menu item underlying object', -> 
            $menuWidget.menu('select')
            call = onSelect.calls.mostRecent()

            expect(call.args[2]).toBe nedeme.menus.menuOne.items[0]

          it 'fourth argument should be the nedeme', -> 
            $menuWidget.menu('select')
            call = onSelect.calls.mostRecent()

            expect(call.args[3]).toBe nedeme

