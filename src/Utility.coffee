define ['jquery'], -> 
  class Utility

    @guid: -> 
      # broofa's answer from: http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
      'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = Math.random()*16|0
        v = if c is 'x' then r else (r&0x3|0x8)
        v.toString(16)

    @addAttributes: (markup, obj) -> 
      $markup = $ markup
      for prop, val of obj
        $markup.attr prop, val
      $('<div></div>').append($markup).html()

    @extend: -> 
      $.extend.apply null, arguments

