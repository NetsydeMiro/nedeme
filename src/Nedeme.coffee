define ['MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (MenuItem, Menu, Renderer) -> 
  class Nedeme

    @defaults = 
      activate: (nedeme) -> 
        $(this).menu select: (event, ui) ->
          uid = ui.item.data 'nedemeuid'
          [menuName, menuElement] = nedeme.findMenuElement uid
          justSelected = {}; justSelected[menuName] = menuElement
          $.extend nedeme.selected, justSelected
          if nedeme.options.select.call(this, event, ui.item[0], menuElement, nedeme)
            clamps = nedeme.options.mapClamps nedeme.selected
            for menuName, menu of nedeme.menus
              for menuContainer in nedeme.menuContainers[menuName]
                nedeme._renderMenu(menuName, menu.clamped(clamps), menuContainer)

      select: (evt, $domMenuElement, dataMenuElement, nedeme) -> 
        test = 7
        test2 = 8
      selected: {}
      mapClamps: (selected) -> 
        clamps = {}
        for menuName, element of selected
          clamps[menuName] = element.text
        clamps
      templates: 
        menu:             '<ul>{{items}}</ul>'
        menuItem:         '<li>{{text}}{{subMenu}}</li>'
        menuItemClamped:  ''
        divider:          '<li class="ui-widget-header">{{text}}</li>'

    constructor: (menus, options = {}) -> 
      @options = $.extend {}, Nedeme.defaults, options
      @menus = {}
      @selected = @options.selected
      for name, menu of menus
        @setMenu name, menu

    setMenu: (name, menu) ->
      @menus[name] = new Menu menu

    renderMenu: (menuName, menuSelector) -> 
      @menuContainers ?= {} 
      @menuContainers[menuName] ?= []
      @menuContainers[menuName].push($menuContainer = $(menuSelector))

      @_renderMenu menuName, @menus[menuName].clamped(@options.mapClamps @selected), $menuContainer

    updateMenus: (selectedValues) -> 
      for menuName, menuContainers of @menuContainers
        for $menuContainer in menuContainers
          @_renderMenu @menus[menuName].clamped(selectedValues), $menuContainer

    findMenuElement: (uid) -> 
      for menuName, menu of @menus
        return [menuName, foundElement] if foundElement = menu.find(uid)

    _renderMenu: (menuName, menu, $menuContainer) -> 
      @menuWidgets ?= {}
      @menuWidgets[menuName] and @menuWidgets[menuName].remove()
      $menu = $(Renderer.createMarkup menu, @options.templates, @_addMarkupUid)
      $menuContainer.html('').append($menu)
      @options.activate.call $menu, this
      @menuWidgets[menuName] = $menu

    _addMarkupUid: (obj, markup) -> 
      $('<div></div>').append($(markup).attr('data-nedemeuid', obj._uid)).html()

