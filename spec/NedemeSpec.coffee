define ['Nedeme', 'jquery-ui'], (Nedeme) -> 

  describe 'Nedeme', -> 

    $testTarget = null

    beforeEach => 
      $testTarget = $ '<div id="test-target"></div>'
      $('body').append $testTarget

    afterEach -> 
      $testTarget.remove()

    describe '#renderMenu()', -> 

      it 'renders menus', -> 

        menuAb = 
          header: 'AMenu'
          items: [
            {text: 'A1', value: 'a1', submenu: {
              header: 'BMenu', 
              items: [
                {text: 'B1', value: 'b1'}, 
                {text: 'B2', value: 'b2'}
              ]
            }},
            {text: 'A2', value: 'a2'}
          ]

        menuCd = 
          header: 'CMenu'
          items: [
            {text: 'C1', value: 'c1', submenu: {
              header: 'DMenu', 
              items: [
                {text: 'D1', value: 'd1'}, 
                {text: 'D2', value: 'd2'}
              ]
            }},
            {text: 'C2', value: 'c2'}
          ]

        ###
        nedeme = new Nedeme menuOne: menuAb, menuTwo: menuCd

        $menu1 = $('<div id="menu1"></div>').appendTo $testTarget
        $menu2 = $('<div id="menu2"></div>').appendTo $testTarget

        nedeme.renderMenu '#menu1', 'menuOne'
        nedeme.renderMenu '#menu2', 'menuTwo'

        expect($menu1.hasClass 'dropdown').toBe true
        expect($menu2.hasClass 'dropdown').toBe true

        expect($menu1.html()).toEqual "
        <button id='menuOne' class='btn btn-default from-control' type='button' data-toggle='dropdown'>
        "

        expect($menu2.html()).toEqual "
        "
        ###

