define -> 
  Renderer = 

    fillTemplate: (template, object) -> 
      result = template
      for key, value of object
        result = result.replace "{{#{key}}}", value

      result.replace /{{.*}}/, ""

    getMarkup: (menu, menuMarkup, menuItemMarkup) -> 
      if menu 
        itemsMarkup = if menu.items 
          menu.items.map( (item) -> 
            itemMarkup = Renderer.fillTemplate menuItemMarkup, item
            itemMarkup = Renderer.getMarkup item.subMenu, menuMarkup, menuItemMarkup)
              .join("\n")
        else
          ""


        Renderer.fillTemplate menuMarkup, {header: menu.header, items: itemsMarkup}
      else
          ""

