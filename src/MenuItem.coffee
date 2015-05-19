define -> 
  class MenuItem 

    constructor: (@value, @text, @clamps = {}, @subMenu = [], @data = null) -> 
      if @value == Object(@value)
        @load(@value)

    isClamped: (selections) -> 
      for property, value of selections
        return true if @clamps[property] and value in @clamps[property] 
      return false

    load: (obj) -> 
      @value = obj.value
      @text = obj.text
      @clamps = obj.clamps ? {}
      @subMenu = obj.subMenu || []
      @data = obj.data
