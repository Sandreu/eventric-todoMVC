eventric = require 'eventric'

remoteStore = false
module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->
  if not remoteStore
    return resolve _loadTodoMVC()

  EventricStoreRemote          = require 'eventric-store-remote'
  eventricRemoteSocketIoClient = require 'eventric-remote-socketio-client'

  eventricRemoteSocketIoClient.initialize {}, ->

    eventric.addStore 'remote', EventricStoreRemote,
      remoteClient: eventricRemoteSocketIoClient
    eventric.set 'default domain events store', 'remote'

    todomvc = _loadTodoMVC()
    resolve todomvc
