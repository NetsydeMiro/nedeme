define -> 
  Renderer = 

    fillTemplate: (template, object, objectOverride) -> 
      result = template
      for key, value of object
        value = objectOverride[key] if objectOverride and objectOverride[key]
        result = result.replace "{{#{key}}}", value

      result.replace /{{.*}}/, ""

    getMarkup: (menu, menuMarkup, menuItemMarkup) -> 
      return '' unless menu

      itemsMarkup = if menu.items 
        menu.items.map( (item) -> 

          overriddenProperties = if item.subMenu 
            {subMenu: Renderer.getMarkup item.subMenu, menuMarkup, menuItemMarkup }
          else
            {}

          Renderer.fillTemplate menuItemMarkup, item, overriddenProperties
        ).join('')
      else
        ""

      Renderer.fillTemplate menuMarkup, {header: menu.header, items: itemsMarkup}

