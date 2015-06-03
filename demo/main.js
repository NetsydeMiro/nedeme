requirejs.config({
  baseUrl: '../src', 

  paths: {
    'jquery':     '../lib/jquery-2.1.3',
    'jquery-ui':  '../lib/jquery-ui-1.11.4-core-menu'
  }, 

  shim: {
    'jquery-ui': {
      deps: ['jquery'], 
      exports: '$'
    }
  }
});

requirejs(['Nedeme'], function(Nedeme) {

  var menuDefinitions = 
  {
    menu1: {items: [
      {text: 'OneOne', value: 11},
      {text: 'OneTwo', value: 12},
      {text: 'OneThree', value: 13}]}, 
    menu2: {items: [
      {text: 'TwoOne', value: 21},
      {text: 'TwoTwo', value: 22, 
        subMenu: {items: [
          {text: 'TwoTwoOne', value: 221},
          {text: 'TwoTwoTwo', value: 222},
          {text: 'TwoTwoThree', value: 223}
        ]}},
      {text: 'TwoThree', value: 23}]}, 
    menu3: {items: [
      {text: 'ThreeOne', value: 31},
      {text: 'ThreeTwo', value: 32},
      {text: 'ThreeThree', value: 33}]}, 
  }

  var nedeme = new Nedeme(menuDefinitions);

  nedeme.renderMenu('menu1', '#menu-1');
  nedeme.renderMenu('menu2', '#menu-2');
  nedeme.renderMenu('menu3', '#menu-3');

});
