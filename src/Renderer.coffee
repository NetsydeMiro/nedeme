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

    createMarkup: (menu, markup) -> 
      return '' unless menu

      itemsMarkup = if menu.items 
        menu.items.map( (item) -> 

          expandedItem = if item.subMenu 
            $.extend {}, item, {subMenu: Renderer.createMarkup item.subMenu, markup }
          else
            $.extend {}, item, {subMenu: ""}

          menuItemMarkup = markup[item.markup or 'menuItem']

          Renderer.fillTemplate menuItemMarkup, expandedItem
        ).join('')
      else
        ""

      menuMarkup = markup[menu.markup or 'menu']

      Renderer.fillTemplate menuMarkup, $.extend({}, menu, {items: itemsMarkup})

