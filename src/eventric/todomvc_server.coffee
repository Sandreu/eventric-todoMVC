eventric = require 'eventric'
socketIO = require('socket.io')()

module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->
  eventricStoreMongoDb = require 'eventric-store-mongodb'
  eventricStoreMongoDb.initialize ->
    eventric.set 'store', eventricStoreMongoDb

    todomvc = _loadTodoMVC()

    socketIO.on 'connection', (socket) =>
      console.log 'new socket.io connection'

      socket.on 'RemoteStore:save', (data) =>
        console.log 'received remote save'
        todomvc.getStore().save data.collectionName, data.doc, ->
          socket.emit "RemoteStore:save:#{data.guid}"


      socket.on 'RemoteStore:find', (data) ->
        console.log 'received remote find'
        todomvc.getStore().find data.collectionName, data.query, data.projection, (err, result) ->
          socket.emit "RemoteStore:find:#{data.guid}", result: result


    socketIO.listen 3000

    resolve todomvc