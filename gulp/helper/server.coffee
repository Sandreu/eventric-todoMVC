path              = require "path"
chalk             = require "chalk"
express           = require "express"
connectLiveReload = require "connect-livereload"

server =
  port: 2342
  livereloadPort: 35729
  basePath: path.join __dirname, '..', '..'
  _lr: null
  started: null
  start: ->
    console.log chalk.white("Start Express")

    app = express()
    app.use connectLiveReload()
    app.use express.static(server.basePath)
    app.listen server.port

    app.get '/', (req, res) ->
      res.redirect 'demo/'

    console.log chalk.cyan("Express started: #{server.port}")
    server.started = true
    return

  livereload: ->
    server._lr = require("tiny-lr")()
    server._lr.listen server.livereloadPort
    console.log chalk.cyan("Live-Reload on: #{server.livereloadPort}")
    return

  startLiveReload: ->
    server.start()
    server.livereload()
    return

  notify: (event) ->
    fileName = path.relative(server.basePath, event.path)
    server._lr.changed body:
      files: [fileName]
    return


module.exports = server