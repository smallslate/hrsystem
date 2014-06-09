module.exports = (grunt) ->
  targetEnv = 'development' 
	  
  grunt.initConfig
    coffee :
      app:
        expand: true
        cwd: 'src'
        src: ['**/*.coffee']
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
    env:
      options:
        NODE_CONFIG_DIR: grunt.option('configDir') || "#{__dirname}/lib/app/config"        
      development:
        NODE_ENV: 'development'	
      test:
        NODE_ENV: 'test'
      staging:
        NODE_ENV: 'staging'
      production:
        NODE_ENV: 'production' 
  	
  require('load-grunt-tasks') grunt;          
  grunt.registerTask('default', ["env:#{targetEnv}", 'coffee','concurrent']);
  