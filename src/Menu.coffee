define ['Utility', 'MenuItem'], (Utility, MenuItem) -> 
  class Menu

    constructor: (obj, parentItem = null) -> 
      # menu gets all properties of obj
      for prop, val of obj
        @[prop] = val unless prop is 'items'

      # except items, which are treated differently
      @items = (new MenuItem(itemObject, Menu, this) for itemObject in obj.items)

      @parent = parentItem
      @_uid ?= Utility.guid()

    equals: (obj) -> 
      result = true

      # menu must contain all properties of obj
      for prop, val of obj
        unless prop is 'items'
          result &= @[prop] is val

      # items have their own equality check
      result &&= @items.length is obj.items.length and 
        [0...@items.length].every((i) => @items[i].equals(obj.items[i]))

    find: (uid) -> 
      flatResult = @_filterAll (el) -> el._uid == uid

      if flatResult.length > 0
        flatResult[0]
      else
        null

    # filters menu of those items that don't pass the requisite clamps
    clamped: (clamps) -> 
      @_filterItems( (menuItem) -> menuItem.passesClamps(clamps) )

    _filterItems: (predicate) -> 
      result = new Menu(@)
      result.items = for item in result.items when predicate.call(null, item)
        item.subMenu = item.subMenu and item.subMenu._filterItems(predicate)
        item

      result 

    _filterAll: (predicate) -> 

      filterAllHelper = (element, result) -> 
        if predicate.call(null, element)
          result.push element

        if element.items 
          for item in element.items
            result = result.concat filterAllHelper(item, result)

        else if element.subMenu
          result = result.concat filterAllHelper(element.subMenu, result)

        return result


      filterAllHelper(this, [])

