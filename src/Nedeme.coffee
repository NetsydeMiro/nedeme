define ['MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (MenuItem, Menu, Renderer) -> 
  class Nedeme

    @defaults = 
      activate: -> 
        $(this).menu()
      templates: 
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
      @menuContainers ?= {} 
      @menuContainers[menuName] ?= []
      @menuContainers[menuName].push($menuContainer = $(menuSelector))

      @_renderMenu @menus[menuName], $menuContainer

    updateMenus: (selectedValues) -> 
      for menuName, menuContainers of @menuContainers
        for $menuContainer in menuContainers
          @_renderMenu @menus[menuName].clamped(selectedValues), $menuContainer

    _renderMenu: (menu, $menuContainer) -> 
      $menu = $(Renderer.createMarkup menu, @options.templates, @_addMarkupUid)
      $menuContainer.html('').append($menu)
      @options.activate.call $menu
      $menu

    _addMarkupUid: (obj, markup) -> 
      $('<div></div>').append($(markup).attr('data-nedemeuid', obj._uid)).html()
