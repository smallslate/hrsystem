module.exports = (grunt) ->
  grunt.initConfig
    coffee :
      app:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib/app',
        ext: '.js'
    concurrent:
      target:
        tasks: ['watch', 'nodemon']
        options:
          logConcurrentOutput: true

    nodemon:
      app:
        script: 'lib/app/server.js'
        options:
          watch: ['lib/app']
          ext: 'js,coffee'
          delay: 3
    watch:
      options:
        interrupt: true
      project:
        files: 'package.json'
        tasks: ['install-dependencies']
      app:
        files: 'src/**/*.coffee'
        tasks: ['coffee:app']
                
  require('load-grunt-tasks') grunt;      	
  grunt.registerTask('default', ['coffee','concurrent']);
  