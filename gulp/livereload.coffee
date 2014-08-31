module.exports = (gulp) ->
  server = require './helper/server'

  gulp.task "livereload:start", ->
    server.startLiveReload()
    return
