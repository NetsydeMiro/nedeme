define -> 
  class MenuItem 

    constructor: (obj, MenuConstructor) -> 
      @value = obj.value
      @text = obj.text
      @clamps = obj.clamps ? {}
      @subMenu = obj.subMenu and MenuConstructor and new MenuConstructor(obj.subMenu) || obj.subMenu
      @data = obj.data

    equals: (obj) -> 
      @value == obj.value and @text == obj.text and (@subMenu == obj.subMenu or @subMenu.equals obj.subMenu)

    passesClamps: (clamps) -> 
      if not clamps
        return true
      else
        for property, value of clamps 
          return true if @clamps[property] and value in @clamps[property] 
        return false

