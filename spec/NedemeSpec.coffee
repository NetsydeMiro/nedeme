define ['Nedeme', 'jquery-ui'], (Nedeme) -> 

  describe 'Nedeme', -> 

    $testTarget = null

    beforeEach => 
      $testTarget = $ '<div id="test-target"></div>'
      $('body').append $testTarget

    afterEach -> 
      $testTarget.remove()

    describe '#renderMenu()', -> 

      it 'renders default menus', -> 

        menuAb = 
          items: [
            {text: 'A1', subMenu: {
              items: [
                {text: 'B1'}, 
                {text: 'B2'}
              ]
            }},
            {text: 'A2'}
          ]

        menuCd = 
          items: [
            {text: 'C1', subMenu: {
              items: [
                {text: 'D1'}, 
                {text: 'D2'}
              ]
            }},
            {text: 'C2'}
          ]

        nedeme = new Nedeme menuOne: menuAb, menuTwo: menuCd

        $menu1 = $('<div id="menu1"></div>').appendTo $testTarget
        $menu2 = $('<div id="menu2"></div>').appendTo $testTarget

        nedeme.renderMenu '#menu1', 'menuOne'
        nedeme.renderMenu '#menu2', 'menuTwo'

        expect($menu1.html()).toEqual "
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

        expect($menu2.html()).toEqual "
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

