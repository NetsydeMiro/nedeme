define ['Utility', 'MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (Utility, MenuItem, Menu, Renderer) -> 
  # TODO: Pull out jquery dependencies into utility or renderer block, to allow swapping in another library
  # or eliminate dependencies altogether
  class Nedeme

    @defaults = 
      activate: (nedeme) -> 
        $(this).menu select: (event, ui) ->
          uid = ui.item.data 'nedemeuid'
          [menuName, menuElement] = nedeme.findMenuElement uid
          justSelected = {}; justSelected[menuName] = menuElement
          Utility.extend nedeme.selected, justSelected
          if nedeme.options.select.call(this, event, ui.item[0], menuElement, nedeme)
            for menuName, menu of nedeme.menus
              nedeme._updateMenu menuName

      select: (evt, $domMenuElement, dataMenuElement, nedeme) -> 
        test = 7
        test2 = 8

      selected: {}

      mapClamp: (menuName, selectedItem) -> 
        selectedItem and selectedItem.text or null

      templates: 
        menu:             '<ul style="width: 200px">{{items}}</ul>'
        menuItem:         '<li>{{text}}{{subMenu}}</li>'

        # TODO: make items specify removeUnless & disableUnless
        menuItemRemoved:  ''
        menuItemDisabled:  ''
        divider:          '<li class="ui-widget-header">{{text}}</li>'

    constructor: (menus, options = {}) -> 
      @options = Utility.extend true, {}, Nedeme.defaults, options
      @menus = {}
      @selected = @options.selected
      for name, menu of menus
        @setMenu name, menu

    setMenu: (name, menu) ->
      @menus[name] = new Menu menu

    renderMenu: (menuName, menuSelector) -> 
      @menuContainers ?= {} 
      @menuContainers[menuName] ?= $()
      @menuContainers[menuName].add($menuContainer = $(menuSelector))

      @_renderMenu menuName

    ###
    updateMenus: (selectedValues) -> 
      for menuName, menuContainers of @menuContainers
        for $menuContainer in menuContainers
          @_renderMenu @menus[menuName].clamped(selectedValues), $menuContainer
    ###

    findMenuElement: (uid) -> 
      for menuName, menu of @menus
        return [menuName, foundElement] if foundElement = menu.find(uid)

    #TODO: replace with _updateMenu, that walks menu dom and updates it according to menu internals
    _renderMenu: (menuName) -> 
      @menuWidgets ?= {}
      @menuWidgets[menuName] and @menuWidgets[menuName].remove()
      menu = @menus[menuName].clamped(@_mapClamps())
      $menu = $(Renderer.createMarkup menu, @options.templates, @_addMarkupUid)
      @menuContainers[menuName].html('').append($menu)
      @options.activate.call $menu, this
      @menuWidgets[menuName] = $menu

    _addMarkupUid: (obj, markup) -> 
      Utility.addAttributes markup, {'data-nedemeuid': obj._uid}

    _mapClamps: -> 
      clamps = {}
      for menuName, menu of @menus
        clamps[menuName] = @options.mapClamp menuName, @selected[menuName]
      clamps

