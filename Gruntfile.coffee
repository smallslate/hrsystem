module.exports = (grunt) ->
  targetEnv = 'development' 
	  
  grunt.initConfig
    coffee :
      app:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
        dest: 'app',
        ext: '.js'
    copy :
      views :
        expand:true
        cwd: 'src'
        src: ['views/**/*.jade']
        dest: 'app'
      public :
        cwd: 'src'
        expand:true
        src: ['public/**/*']
        dest: 'app'
    concurrent:
      target:
        tasks: ['watch', 'nodemon']
        options:
          logConcurrentOutput: true
    nodemon:
      app:
        script: 'app/server.js'
        options:
          watch: ['app']
          ignore: ['public/**'],
          ext: 'js'
          delay: 3
    watch:
      options:
        interrupt: true
      app:
        files: 'src/**/*.coffee'
        tasks: ['coffee:app']
      views:
        files: 'src/views/**/*.jade'
        tasks: ['copy:views']  
      public:
        files: 'src/public/**/*'
        tasks: ['copy:public']   

  require('load-grunt-tasks') grunt;          
  grunt.registerTask('default',['coffee','copy','concurrent']);
  