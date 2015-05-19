define ['MenuItem'], (MenuItem) -> 

  class Menu

    constructor: (obj) -> 
      @header = obj.header
      @items = (new MenuItem(itemObject, Menu) for itemObject in obj.items)

    equals: (obj) -> 
      @header == obj.header and @items.length == obj.items.length and 
        [0...@items.length].every((i) => @items[i].equals(obj.items[i]))

    clamped: (clamps) -> 
      clamped = new Menu(@)
      clamped.items = for item in clamped.items when item.passesClamps(clamps)
        item.subMenu = item.subMenu and item.subMenu.clamped clamps
        item

      clamped

