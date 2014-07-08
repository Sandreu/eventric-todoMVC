eventric = require 'eventric'

module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->
  eventricStoreMongoDb = require 'eventric-store-mongodb'
  eventricStoreMongoDb.initialize ->
    eventric.set 'store', eventricStoreMongoDb

    todomvc = _loadTodoMVC()

    eventric.addDomainEventHandler (domainEvent) ->
      process.nextTick =>
        console.log todomvc.getProjection('TodoStats').stats

    require('./eventric-remote-store')(todomvc)

    resolve todomvc.initialize()