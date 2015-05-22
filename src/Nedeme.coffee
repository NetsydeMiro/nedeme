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

    renderMenu: (menuName, menuSelector) -> 
      $menu = $(Renderer.createMarkup @menus[menuName], @options.markup)
      $menuContainer = $(menuSelector).html('').append($menu)
      @options.activate.call $menu

      @menuSelectors ?= {} 
      @menuSelectors[menuName] ?= []
      @menuSelectors[menuName].push menuSelector
      $menu

    updateMenus: -> 
      for menuName, menuSelectors of @menuSelectors
        for menuSelector in menuSelectors
          @renderMenu menuName, menuSelector

