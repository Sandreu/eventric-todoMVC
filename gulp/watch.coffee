module.exports = (gulp) ->

  server = require './helper/server'

  gulp.task "watch", ->
    sources = [
      "./src/**/*.coffee"
    ]
    watcher = gulp.watch sources, ["build"]
    watcher.on 'change', (event) ->
      server.notify event
    return