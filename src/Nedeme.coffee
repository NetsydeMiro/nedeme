define ['MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (MenuItem, Menu, Renderer) -> 
  class Nedeme

    @defaults = 
      activate: (nedeme) -> 
        $(this).menu select: (event, ui) ->
          uid = ui.item.data 'nedemeuid'
          [menuName, menuElement] = nedeme.findMenuElement uid
          justSelected = {}; justSelected[menuName] = menuElement
          $.extend nedeme.selected, justSelected
          nedeme.options.select.call this, event, ui.item[0], menuElement, nedeme

      select: (evt, $domMenuElement, dataMenuElement, nedeme) -> 
        test = 7
        test2 = 8
      selected: {}
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

      @_renderMenu @menus[menuName], $menuContainer

    updateMenus: (selectedValues) -> 
      for menuName, menuContainers of @menuContainers
        for $menuContainer in menuContainers
          @_renderMenu @menus[menuName].clamped(selectedValues), $menuContainer

    findMenuElement: (uid) -> 
      for menuName, menu of @menus
        return [menuName, foundElement] if foundElement = menu.find(uid)

    _renderMenu: (menu, $menuContainer) -> 
      $menu = $(Renderer.createMarkup menu, @options.templates, @_addMarkupUid)
      $menuContainer.html('').append($menu)
      @options.activate.call $menu, this
      $menu

    _addMarkupUid: (obj, markup) -> 
      $('<div></div>').append($(markup).attr('data-nedemeuid', obj._uid)).html()

