
module.exports = (g) ->

  g.initConfig

    clean: ['public']

    stylus:
      compile:
        options:
          compress: process.env['DEBUG'] || false
          paths: ['src/css']
          urlfunc: { name: 'url', limit: 1000000 }
        "include css": true
        files:
          'build/css/style.css': 'src/css/style.styl'

    preprocess:
      js:
        src: 'public/js/app.js'
        options:
          inline: true
          context:
            DEBUG: process.env['DEBUG'] || false
      html:
        src: 'public/**/*.html'
        options:
          inline: true
          context:
            DEBUG: process.env['DEBUG'] || false

    inline:
      dist:
        options: 
          cssmin: true
        src: ['build/index.html']
        dest: ['tumble_build/']

    uglify:
      js:
        files:
          'public/js/app.min.js': ['public/js/app.js']

    assemble:
      site:
        options:
          partials: 'src/partials/**/*.hbs'
          flatten: true
        src: ['src/*.hbs']
        dest: './build/'

    browserify:
      dist: 
        files:
          'build/js/app.js': ['./src/js/**/*.js']

    browserSync:
      bsFiles:
        src : './src/css/*.css'
      options: 
        server:
          baseDir: "./build/"

    watch:
      hbs:
        files: ['src/**/*.hbs']
        tasks: ['html']
      css:
        files: ['src/css/**/**.styl']
        tasks: 'css'
      js:
        files: ['src/js/**/*.js']
        tasks: 'browserify'
      img:
        files: ['src/images/**/*.{html,json,png,jpg,gif}']
        tasks: 'img'

    g.registerTask 'html', ['assemble','preprocess:html']

    g.registerTask 'css', 'stylus'

    g.registerTask 'build', ['clean', 'html', 'css', 'js', 'img']

    g.registerTask 'default', ['build', 'watch']
    
    g.registerTask 'js', ['browserify','preprocess:js','uglify']

    g.loadNpmTasks 'grunt-contrib-clean'
    
    g.loadNpmTasks 'grunt-contrib-stylus'
    
    g.loadNpmTasks 'grunt-browserify'

    g.loadNpmTasks 'grunt-browser-sync'

    g.loadNpmTasks 'grunt-preprocess'

    g.loadNpmTasks 'grunt-inline'

    g.loadNpmTasks 'assemble';