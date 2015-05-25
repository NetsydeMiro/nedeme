define ['jquery'], -> 
  Renderer = 

    fillTemplate: (template, object, ignoredProperties = []) -> 

      fillTemplateHelper = (template, object, prefix) -> 
        result = template
        for key, value of object when key not in ignoredProperties
          if $.type(value) is 'object' 
            result = fillTemplateHelper result, value, key + '-'
          else
            result = result.replace "{{#{prefix + key}}}", value

        result

      fillTemplateHelper(template, object, '')

    createMarkup: (menu, markup) -> 
      return '' unless menu

      domDictionary = {}

      itemsMarkup = if menu.items 
        menu.items.map( (item) -> 

          expandedItem = if item.subMenu 
            $.extend {}, item, {subMenu: Renderer.createMarkup item.subMenu, markup }
          else
            $.extend {}, item, {subMenu: ""}

          menuItemMarkup = markup[item.markup or 'menuItem']

          filled = Renderer.fillTemplate menuItemMarkup, expandedItem
          domDictionary[item] = $(filled)
          filled

        ).join('')
      else
        ""

      menuMarkup = markup[menu.markup or 'menu']

      filled = Renderer.fillTemplate menuMarkup, $.extend({}, menu, {items: itemsMarkup})
      domDictionary[menu] = $(filled)
      
      filled

