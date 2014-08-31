module.exports = (gulp) ->

  server = require './helper/server'

  gulp.task "watch", ->
    sources = [
      "./src/**/*.coffee"
    ]
    watcher = gulp.watch sources, ["scripts"]
    watcher.on 'change', (event) ->
      server.notify event
    return