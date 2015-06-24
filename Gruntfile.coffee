extend = require 'extend'

defaults = 

  coffee: 
    options: 
      join: false
      sourceMap: true
    expand: true
    flatten: true
    dest: 'compiled'
    ext: '.js'

  jasmine: 
    src: 'compiled/src/*.js'
    options:
      specs: 'compiled/spec/*.js'
      template: require('grunt-template-jasmine-requirejs')
      templateOptions: 
        requireConfig: 
          baseUrl: 'compiled/src'
          paths:
            'jquery': '../../lib/jquery-2.1.3'
            'jquery-ui': '../../lib/jquery-ui-1.11.4-button-menu'
            'mock-ajax': '../../lib/mock-ajax'
          shim: 
            'jquery-ui':
              exports: '$'
              deps: ['jquery']

module.exports = (grunt) -> 
  grunt.initConfig

    coffee:
      source: 
        extend {}, defaults.coffee, {src: 'src/*.coffee', dest: 'compiled/src'}
      spec: 
        extend {}, defaults.coffee, {src: 'spec/*.coffee', dest: 'compiled/spec'}

    watch:
      coffee: 
        files: ['spec/*.coffee', 'src/*.coffee']
        tasks: 'coffee'
      jasmine:
        files: 'compiled/**/*.js'
        tasks: 'jasmine:dev'

    jasmine: 
      # we keep _SpecRunner.html around when devving to help debug
      dev: 
        extend true, {}, defaults.jasmine, {options: {keepRunner: true}}
      prod: 
        defaults.jasmine

    livereloadx: 
      static: true
      filter: 
        [{type: 'exclude', pattern: '{.git,lib,node_modules}/'},
        {type: 'include', pattern: '/'},
        {type: 'include', pattern: '*/'},
        {type: 'include', pattern: '**/*.{html,js,css,amaze}'},
        {type: 'exclude', pattern: '*'}]
  
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'livereloadx'

  grunt.registerTask 'test', ['jasmine:prod']

  grunt.registerTask 'default', ['coffee', 'test']
  grunt.registerTask 'travis', ['default']

  grunt.registerTask 'serve', ['livereloadx', 'watch:coffee']
  grunt.registerTask 'dev', ['livereloadx', 'watch']
