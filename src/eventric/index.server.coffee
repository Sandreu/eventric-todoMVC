eventric = require 'eventric'

module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->
  eventricSocketIORemoteEndpoint = require 'eventric-remote-socketio-endpoint'
  EventricStoreMongoDb           = require 'eventric-store-mongodb'
  eventric.addStore 'mongodb', EventricStoreMongoDb
  eventric.set 'default domain events store', 'mongodb'

  eventricSocketIORemoteEndpoint.initialize {}, ->
    eventric.addRemoteEndpoint 'socketio', eventricSocketIORemoteEndpoint

    todomvc = _loadTodoMVC()

    todomvc.initialize ->
      resolve todomvc
