socketIO = require('socket.io')()

module.exports = (todomvc) ->

  socketIO.on 'connection', (socket) =>
    console.log 'new socket.io connection'

    socket.on 'RemoteStore:save', (data) =>
      #console.log 'received remote save', data.guid
      todomvc.getStore().save data.collectionName, data.doc, ->
        todomvc.getEventBus().publishDomainEvent data.doc
        socket.emit "RemoteStore:save:#{data.guid}"


    socket.on 'RemoteStore:find', (data) ->
      #console.log 'received remote find', data.guid
      todomvc.getStore().find data.collectionName, data.query, data.projection, (err, result) ->
        socket.emit "RemoteStore:find:#{data.guid}", result: result


  socketIO.listen 3000