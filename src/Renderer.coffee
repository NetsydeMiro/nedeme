define -> 
  Renderer = 

    fillTemplate: (template, object) -> 
      result = template
      for key, value of object
        result = result.replace "{{#{key}}}", value

      result.replace /{{.*}}/, ""

