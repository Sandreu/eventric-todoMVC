eventric = require 'eventric'

eventric.set 'store', require './eventric-store-inmemory'


todomvc = eventric.boundedContext 'todomvc'

  .addDomainEvents require './domain/events'
  .addAggregate 'Todo', require './domain/todo'
  .addCommandHandlers require './application/commandhandlers'
  .addReadModel 'Todos', require './domain/todos_projection'
  .initialize()


module.exports = todomvc