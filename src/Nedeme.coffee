define ['MenuItem', 'Menu', 'Renderer', 'jquery-ui'], (MenuItem, Menu, Renderer) -> 
  class Nedeme

    @defaults = 
      markup: 
        menu: '<ul>{{items}}</ul>'
        menuItem: '<li>{{text}}{{subMenu}}</li>'
        divider: '<li class="ui-widget-header">{{text}}</li>'

    constructor: (menus, options = {}) -> 
      @options = $.extend {}, Nedeme.defaults, options
      @menus = {}
      for name, menu of menus
        @menus[name] = new Menu menu

    renderMenu: (menuSelector, menuName) -> 
      menuMarkup = Renderer.createMarkup @menus[menuName], @options.markup
      $(menuSelector).append menuMarkup

