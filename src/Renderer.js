(function() {
  define(function() {
    var Renderer;
    return Renderer = {
      fillTemplate: function(template, object) {
        var key, result, value;
        result = template;
        for (key in object) {
          value = object[key];
          result = result.replace("{{" + key + "}}", value);
        }
        return result.replace(/{{.*}}/, "");
      }
    };
  });

}).call(this);

//# sourceMappingURL=Renderer.js.map
