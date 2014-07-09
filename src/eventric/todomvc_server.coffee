eventric = require 'eventric'

module.exports = (_loadTodoMVC) -> new Promise (resolve, reject) ->
  eventricStoreMongoDb = require 'eventric-store-mongodb'
  eventricStoreMongoDb.initialize ->
    eventric.set 'store', eventricStoreMongoDb

    todomvc = _loadTodoMVC()

    console.log 'registered global domain event handler'
    eventric.addDomainEventHandler (domainEvent) ->
      process.nextTick =>
        console.log 'wat', todomvc.getProjection('TodoStats').stats

    require('./eventric-remote-store')(todomvc)

    resolve todomvc