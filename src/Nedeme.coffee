define ['Utility', 'MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (Utility, MenuItem, Menu, Renderer) -> 
  # TODO: Pull out jquery dependencies into utility or renderer block, to allow swapping in another library
  # or eliminate dependencies altogether
  class Nedeme

    @defaults = 
      activateTrigger: (nedeme, menuName) -> 
        $(this).button(icons: {secondary: 'ui-icon-triangle-l-s'})
        .click -> nedeme.dropdownWidgets[menuName].toggle()

      activateDropdown: (nedeme) -> 
        $(this).menu 
          select: (event, ui) ->
            uid = ui.item.data 'nedemeuid'
            [menuName, menuElement] = nedeme.findMenuElement uid
            nedeme.selected[menuName] = menuElement
            if nedeme.options.select.call(this, event, ui.item[0], menuElement, nedeme, menuName)
              for name, _ of nedeme.menus
                nedeme._renderDropdown name
              nedeme._updateTriggerText menuName

      select: (evt, $domMenuElement, dataMenuElement, nedeme, menuName) -> 
        true

      selected: {}

      mapClamp: (menuName, selectedItem) -> 
        selectedItem and selectedItem.text or null

      mapTriggerText: (menuName, selectedItem) -> 
        name = @menus[menuName].menuName or menuName
        ancestorBranch = Utility.ancestorBranch.call(selectedItem)
          .filter (it) -> it.constructor is MenuItem
          .map (it) -> it.text
        lineage = ancestorBranch.join ' - ' 
        name + ': ' + lineage


      templates: 
        trigger:      '<button>{{menuName}}</button>'
        menu:         '<ul style="width: 200px">{{items}}</ul>'
        menuItem:     '<li>{{text}}{{subMenu}}</li>'
        divider:      '<li class="ui-widget-header">{{text}}</li>'

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
      @menuContainers[menuName] = @menuContainers[menuName].add $(menuSelector)

      @_renderTrigger menuName
      @_renderDropdown menuName

    findMenuElement: (uid) -> 
      for menuName, menu of @menus
        return [menuName, foundElement] if foundElement = menu.find(uid)

    _renderDropdown: (menuName) -> 
      @dropdownWidgets ?= {}
      @dropdownWidgets[menuName] and @dropdownWidgets[menuName].remove()
      menu = @menus[menuName].clamped(@_mapClamps())
      $menu = $(Renderer.createMarkup menu, @options.templates, @_addMarkupUid)
      @menuContainers[menuName].append($menu)
      @options.activateDropdown.call $menu, this
      $menu.hide()
      @dropdownWidgets[menuName] = $menu

    _renderTrigger: (menuName) -> 
      @triggerWidgets ?= {}
      $trigger = $(Renderer.fillTemplate @options.templates.trigger, {menuName: @menus[menuName].name or menuName })
      @menuContainers[menuName].append($trigger)
      @options.activateTrigger.call $trigger, this, menuName
      @triggerWidgets[menuName] = $trigger

    _updateTriggerText: (menuName) -> 
      updatedText = @options.mapTriggerText.call @, menuName, @selected[menuName]
      @triggerWidgets[menuName].button 'option', 'label', updatedText
      #@triggerWidgets[menuName].button 'refresh'

    #TODO: add _updateMenu, that walks menu dom and updates it according to menu internals

    _addMarkupUid: (obj, markup) -> 
      Utility.addAttributes markup, {'data-nedemeuid': obj._uid}

    _mapClamps: -> 
      clamps = {}
      for menuName, menu of @menus
        clamps[menuName] = @options.mapClamp menuName, @selected[menuName]
      clamps

