(function() {
  define(['Renderer'], function(Renderer) {
    return describe('Renderer', function() {
      return describe('::fillTemplate', function() {
        it('fills the template', function() {
          var result, template;
          template = "This is a {{value}} template";
          result = Renderer.fillTemplate(template, {
            value: "test"
          });
          return expect(result).toEqual("This is a test template");
        });
        it('removes unknown placeholders', function() {
          var result, template;
          template = "This is a {{value}} template";
          result = Renderer.fillTemplate(template, {
            value2: "not entered"
          });
          return expect(result).toEqual("This is a  template");
        });
        return it('fills multiple placeholders', function() {
          var result, template;
          template = "This is a {{value}} template. {{fin}}.";
          result = Renderer.fillTemplate(template, {
            value: "test",
            fin: 'Finito'
          });
          return expect(result).toEqual("This is a test template. Finito.");
        });
      });
    });
  });

}).call(this);

//# sourceMappingURL=RendererSpec.js.map
