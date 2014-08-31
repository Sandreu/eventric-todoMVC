gutil       = require "gulp-util"
plugins     = require("gulp-load-plugins")(lazy: false)
compile     = require "gulp-compile-js"
karma       = require 'gulp-karma'
chalk       = require "chalk"
commonjs    = require 'gulp-wrap-commonjs'

bowerPkg    = require "../bower.json"


module.exports = (gulp) ->

  getVendorSources = (minified = false)->
    sources = []
    for packageName, version of bowerPkg.dependencies
      fileName = packageName
      fileName += '.min' if minified
      sources.push "./bower_components/#{packageName}/**/*#{fileName}.js"

    sources.push './bower_components/simpleStorage/simpleStorage.js'
    sources.push './bower_components/socket.io-client/socket.io.js'
    sources.push "./node_modules/eventric/build/release/eventric.js"
    sources

  gulp.task "scripts", ["scripts:angular", "scripts:eventric", "scripts:vendor"]

  gulp.task "scripts:angular", ->
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

  gulp.task "scripts:eventric", ->
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


  gulp.task "scripts:vendor", ->
    sources = getVendorSources()

    getPackageName = (v) -> v.split('/').reverse()[0]
    console.log chalk.cyan("Adding [#{chalk.magenta(sources.map getPackageName)}] to vendors.js")

    gulp.src(sources)
    .pipe(plugins.concat("vendor.js"))
    .pipe gulp.dest("./build")
    return

