define ['jquery'], -> 
  Renderer = 

    fillTemplate: (template, object) -> 

      fillTemplateHelper = (template, object, prefix) -> 
        result = template
        for key, value of object
          if $.type(value) is 'object'
            result = fillTemplateHelper result, value, key + '-'
          else
            result = result.replace "{{#{prefix + key}}}", value

        result

      fillTemplateHelper(template, object, '')

    getMarkup: (menu, menuMarkup, menuItemMarkup) -> 
      return '' unless menu

      itemsMarkup = if menu.items 
        menu.items.map( (item) -> 

          expandedItem = if item.subMenu 
            $.extend {}, item, {subMenu: Renderer.getMarkup item.subMenu, menuMarkup, menuItemMarkup }
          else
            $.extend {}, item, {subMenu: ""}

          Renderer.fillTemplate menuItemMarkup, expandedItem
        ).join('')
      else
        ""

      Renderer.fillTemplate menuMarkup, {header: menu.header, items: itemsMarkup}

