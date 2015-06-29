# Utility.litcoffee

Utility class for shared functionality in the form of static methods. 
Also, we should wrap any external library dependant code here, so that it can easiy be factored out later if desired.

    define ['jquery'], -> 
      class Utility

Method to generate a guid.
Adapted from broofa's answer here: http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript

        @guid: -> 
          'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
            r = Math.random()*16|0
            v = if c is 'x' then r else (r&0x3|0x8)
            v.toString(16)

Adds attributes to markup.

        @addAttributes: (markup, obj) -> 
          $markup = $ markup
          for prop, val of obj
            $markup.attr prop, val
          $('<div></div>').append($markup).html()

Wrapper for jQuery's useful extend method.

        @extend: -> 
          $.extend.apply null, arguments

Utility method to be bolted onto a hierarchical object.
Hierarchical object requires a parent property, that holds a reference to its parent (if present).
Returns a list representing an ancestor branch (from eldest to youngest, the youngest being the object itself)

        @ancestorBranch: -> 
          if not @parent
            [this]
          else
            result = Utility.ancestorBranch.call(@parent)
            result.push this
            result
