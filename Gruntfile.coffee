module.exports = (grunt)->

  coffeeify = require "coffeeify"
  stringify = require "stringify"

  grunt.initConfig
    connect:
      server:
        options:
          port: 3000
          base: ["."]

    clean: 
      bin: ["bin", "pages", "index.html"]

    copy:
      index:
        src: "pages/index.html"
        dest: "index.html"

    browserify: 
      dev: 
        options:
          preBundleCB: (b)->
            b.transform(coffeeify)
            b.transform(stringify({extensions: [".hbs", ".html", ".tpl", ".txt"]}))
        expand: true
        flatten: true
        src: ["src/js/*.coffee"]
        dest: "bin/js"
        ext: ".js"

    less:    
      dev:
        files: [{
          expand: true
          cwd: "src/css/"
          src: ["*.less"]
          dest: "bin/css"
          ext: ".css"
        }]

    cssmin:    
      build:
        files:
          "dist/css/style.min.css": ["bin/css/main.css"]
    watch:
      compile:
        options:
          livereload: true
        files: [
          "src/**/*.coffee", 
          "src/**/*.less", 
          "src/**/*.html", 
          "index.html", 
          "test/**/*.coffee", 
          "test/**/*.html", 
          "src/**/*.jade",
          "src/**/*.json"
        ]
        tasks: ["browserify", "less", "jade", "copy:index"]

    jade:
      dev:
        options:
          data: (dest, src)->
            src = src[0]
            view = (src.match /\/[\w\-]+\.jade$/g)[0].replace /(\/)|(\.jade)/g, ""
            try
              console.warn "./src/mocks/#{view}.coffee is not found, use {}. But no worries." 
              data = require "./src/mocks/#{view}.coffee"
            catch e
              data = {}
            data
        files: [{
            expand: true
            cwd: "src/views/"
            src: ["*.jade"]
            dest: "pages/"
            ext: ".html"
        }]

  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-jade"

  grunt.registerTask "default", ->
    grunt.task.run [
      "clean:bin"
      "browserify"
      "less"
      "jade"
      "copy:index"
      "connect"
      "watch"
    ]

  grunt.registerTask "build", ->
    grunt.task.run [
      "clean:bin"
      "browserify"
      "less"
      "jade"
      "copy:index"
    ]
