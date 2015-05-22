define -> 
  class MenuItem 

    constructor: (obj, MenuConstructor) -> 
      # MenuItem gets all properties of obj
      for prop, val of obj
        @[prop] = val unless prop in ['clamps','subMenu']

      # except clamps (which have a default) and suMenu (which should have a constructor)
      @clamps = obj.clamps ? {}
      @subMenu = obj.subMenu and MenuConstructor and new MenuConstructor(obj.subMenu) || obj.subMenu

    equals: (obj) -> 
      result = true
      # we don't care about clamps for equality
      for prop, val of obj
        result &= this[prop] is val unless prop in ['clamps','subMenu']

      # subMenu has its own equality check
      result &= @subMenu is obj.subMenu or @subMenu.equals obj.subMenu

    # returns true if this item should not be clamped
    passesClamps: (clamps) -> 
      if not clamps
        return true
      else
        for property, value of clamps 
          return false if @clamps[property] and value not in @clamps[property] 
        return true 

