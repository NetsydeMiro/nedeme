define ['MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (MenuItem, Menu, Renderer) -> 
  class Nedeme

    @defaults = 
      activate: -> $(this).menu()
      markup: 
        menu: '<ul>{{items}}</ul>'
        menuItem: '<li>{{text}}{{subMenu}}</li>'
        divider: '<li class="ui-widget-header">{{text}}</li>'

    constructor: (menus, options = {}) -> 
      @options = $.extend {}, Nedeme.defaults, options
      @menus = {}
      for name, menu of menus
        @setMenu name, menu

    setMenu: (name, menu) ->
      @menus[name] = new Menu menu

    renderMenu: (menu, menuSelector) -> 
      $menu = $(Renderer.createMarkup menu, @options.markup)
      $menuContainer = $(menuSelector).html('').append($menu)
      @options.activate.call $menu
      $menu

    plantMenu: (menuName, menuSelector) -> 
      @menuSelectors ?= {} 
      @menuSelectors[menuName] ?= []
      @menuSelectors[menuName].push menuSelector

      @renderMenu @menus[menuName], menuSelector

    updateMenus: (selectedValues) -> 
      for menuName, menuSelectors of @menuSelectors
        for menuSelector in menuSelectors
          @renderMenu @menus[menuName].clamped(selectedValues), menuSelector

