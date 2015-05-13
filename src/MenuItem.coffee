define -> 
  class MenuItem 

    constructor: (@value, @text, @clamps, @data) -> 

    isClamped: (selections) -> 
      for property, value in selections
        return true if @clamps[property] == value

