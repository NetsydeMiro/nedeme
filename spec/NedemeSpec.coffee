define ['Nedeme', 'jquery-ui'], (Nedeme) -> 

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

        expect($menu1.html()).toEqual expected1

        expect($menu2.html()).toEqual expected2

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

        expect($menu1.html()).toEqual expected1

        expect($menu2.html()).toEqual expected2

