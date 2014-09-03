eventric = require 'eventric'

module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->

  EventricStoreRemote          = require 'eventric-store-remote'
  eventricRemoteSocketIoClient = require 'eventric-remote-socketio-client'

  eventricRemoteSocketIoClient.initialize {}, ->

    eventric.addStore 'remote', EventricStoreRemote,
      remoteClient: eventricRemoteSocketIoClient
    #eventric.set 'default domain events store', 'remote'

    todomvc = _loadTodoMVC()
    resolve todomvc
