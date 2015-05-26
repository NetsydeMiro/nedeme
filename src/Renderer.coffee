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

    createMarkup: (menu, templates, onMarkupCreated = (obj, markup) -> markup) -> 
      return '' unless menu

      itemsMarkup = if menu.items 
        menu.items.map( (item) -> 

          expandedItem = if item.subMenu 
            $.extend {}, item, {subMenu: Renderer.createMarkup item.subMenu, templates }
          else
            $.extend {}, item, {subMenu: ""}

          template = templates[item.template or 'menuItem']

          markup = Renderer.fillTemplate template, expandedItem

          onMarkupCreated.call(null, item, markup)

        ).join('')
      else
        ""

      template = templates[menu.template or 'menu']

      markup = Renderer.fillTemplate template, $.extend({}, menu, {items: itemsMarkup})

      onMarkupCreated.call(null, menu, markup)

