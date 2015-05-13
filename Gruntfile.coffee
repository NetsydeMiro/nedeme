module.exports = (grunt) -> 
  grunt.initConfig

    coffee:
      source: 
        expand: true
        src: 'src/*.coffee'
        ext: '.js'
        options: 
          join: false
          sourceMap: true
      spec: 
        expand: true
        src: 'spec/*.coffee'
        ext: '.js'
        options: 
          join: false
          sourceMap: true

    watch:
      compile: 
        files: ['spec/*.coffee', 'src/*.coffee']
        tasks: 'compile'
      test:
        files: ['src/*.js', 'spec/*.js']
        tasks: 'test:dev'

    jasmine: 
      # we keep _SpecRunner.html around when devving to help debug
      dev: 
        src: 'src/**.*.js'
        options:
          specs: 'spec/*.js'
          template: require('grunt-template-jasmine-requirejs')
          templateOptions: 
            requireConfig: 
              baseUrl: 'src/'
              paths:
                'jquery': '../lib/jquery-2.1.3'
                'jquery-ui': '../lib/jquery-ui-1.11.2-core-interactions-effects'
                'mock-ajax': '../lib/mock-ajax'
              shim: 
                'jquery-ui':
                  exports: '$'
                  deps: ['jquery']
          keepRunner: true
      prod: 
        src: 'src/**.*.js'
        options:
          specs: 'spec/*.js'
          template: require('grunt-template-jasmine-requirejs')
          templateOptions: 
            requireConfig: 
              baseUrl: 'src/'
              paths:
                'jquery': '../lib/jquery-2.1.3'
                'jquery-ui': '../lib/jquery-ui-1.11.2-core-interactions-effects'
                'mock-ajax': '../lib/mock-ajax'
              shim: 
                'jquery-ui':
                  exports: '$'
                  deps: ['jquery']

    livereloadx: 
      static: true
      filter: 
        [{type: 'exclude', pattern: '{.git,lib,node_modules}/'},
        {type: 'include', pattern: '/'},
        {type: 'include', pattern: '*/'},
        {type: 'include', pattern: '*.{html,js,css,amaze}'},
        {type: 'exclude', pattern: '*'}]
  
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'livereloadx'

  grunt.registerTask 'compile', ['coffee']
  grunt.registerTask 'test', ['jasmine:prod']
  grunt.registerTask 'test:dev', ['jasmine:dev']

  grunt.registerTask 'default', ['compile', 'test']
  grunt.registerTask 'travis', ['default']

  grunt.registerTask 'serve', ['livereloadx', 'watch:compile']
  grunt.registerTask 'dev', ['livereloadx', 'watch']
