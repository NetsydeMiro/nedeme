define ['MenuItem'], (MenuItem) -> 
  class Menu

    constructor: (obj) -> 
      # menu gets all properties of obj
      for prop, val of obj
        @[prop] = val unless prop is 'items'

      # except items, which are treated differently
      @items = (new MenuItem(itemObject, Menu) for itemObject in obj.items)

    equals: (obj) -> 
      result = true

      # menu must contain all properties of obj
      for prop, val of obj
        unless prop is 'items'
          result &= @[prop] is val

      # items have their own equality check
      result &= @items.length is obj.items.length and 
        [0...@items.length].every((i) => @items[i].equals(obj.items[i]))

    # filters menu of those items that don't pass the requisite clamps
    clamped: (clamps) -> 
      clamped = new Menu(@)
      clamped.items = for item in clamped.items when item.passesClamps(clamps)
        item.subMenu = item.subMenu and item.subMenu.clamped clamps
        item

      clamped

