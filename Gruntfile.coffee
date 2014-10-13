module.exports = (grunt)->

  coffeeify = require "coffeeify"
  stringify = require "stringify"
  fs = require "fs"
  compileJade = require "./compile-jade.coffee"
  data = require "./data.coffee"

  grunt.initConfig
    connect:
      server:
        options:
          port: 3000
          base: ["."]

    clean: 
      bin: ["bin", "pages/*.html", "lists/*.html", "index.html"]

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
          "./*coffee",
          "src/**/*.coffee", 
          "src/**/*.less", 
          "src/**/*.html", 
          "test/**/*.coffee", 
          "test/**/*.html", 
          "src/**/*.jade",
          "src/**/*.json"
        ]
        tasks: ["browserify", "less", "jade"]

    jade:
      dev:
        files: [{
            expand: true
            cwd: "src/views/"
            src: ["payment.jade"]
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

  grunt.registerTask "default", ["build", "jade", "browserify", "less", "connect", "watch"]

  grunt.registerTask "build", ["clean:bin"], ->
    compileJade ->
        grunt.task.run [
          "jade"
          "browserify"
          "less"
        ], ->
        html = fs.readFileSync "lists/1.html"
        fs.writeFileSync "./index.html", html
