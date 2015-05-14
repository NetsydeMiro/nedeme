define ['MenuItem'], (MenuItem) -> 

  class Menu

    constructor: (@header, menuItemObjects) -> 
      @items = (new MenuItem(itemObject) for itemObject in menuItemObjects)

