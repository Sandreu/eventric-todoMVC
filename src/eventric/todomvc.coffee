eventric = require 'eventric'

#eventric.set 'store', require './eventric-store-inmemory'

eventricStoreMongoDb = require 'eventric-store-mongodb'
eventricStoreMongoDb.initialize ->
  eventric.set 'store', eventricStoreMongoDb


todomvc = eventric.boundedContext 'todomvc'

  .addDomainEvents require './domain/events'
  .addAggregate 'Todo', require './domain/todo'
  .addCommandHandlers require './application/commandhandlers'
  .addReadModel 'Todos', require './domain/todos_projection'
  .initialize()


module.exports = todomvc