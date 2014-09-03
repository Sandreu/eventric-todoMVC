gutil       = require "gulp-util"
plugins     = require("gulp-load-plugins")(lazy: false)
compile     = require "gulp-compile-js"
karma       = require 'gulp-karma'
chalk       = require 'chalk'
commonjs    = require 'gulp-wrap-commonjs'
mergeStream = require 'merge-stream'
bowerFiles  = require 'main-bower-files'



module.exports = (gulp) ->

  gulp.task "build", ["build:src:angular", "build:src:eventric", "build:vendor"]

  gulp.task "build:src:angular", ->
    sources =[
      "./src/angular/**/*.coffee"
    ]
    gulp.src(sources)
    .pipe(
      compile
        coffee:
          bare: true
    )
    .pipe plugins.concat("todomvc.js")
    .pipe gulp.dest("./build/angular")
    return

  gulp.task "build:src:eventric", ->
    sources =[
      "./src/eventric/**/*.coffee"
    ]
    gulp.src(sources)
    .pipe(
      compile
        coffee:
          bare: true
    )
    .pipe commonjs
            pathModifier: (path) ->
              path = path.replace /.js$/, ''
              path = path.replace /.*src\//, 'src/'
              path

    .pipe gulp.dest("./build/eventric")
    return


  gulp.task "build:vendor", ->
    nm = gulp.src([
      "./node_modules/eventric/build/dist/eventric.js"
      "./node_modules/eventric-store-remote/build/dist/eventric-store-remote.js"
      "./node_modules/eventric-remote-socketio-client/build/dist/eventric-remote-socketio-client.js"
    ])
    bower = gulp.src(bowerFiles())
    .pipe commonjs
      pathModifier: (path) ->
        matches = path.match /(bower_components|node_modules)\/(.*?)\//
        moduleName = matches[2]
        moduleName

    mergeStream nm, bower
      .pipe(plugins.concat("vendor.js"))
      .pipe gulp.dest("./build")
    return

