eventric = require 'eventric'

_loadTodoMVC = ->
  eventric.boundedContext 'todomvc'
    .addDomainEvents require './domain/events'
    .addAggregate 'Todo', require './domain/todo'
    .addCommandHandlers require './application/commandhandlers'
    .addProjection 'Todos', require './domain/todos_projection'
    .initialize()


# browser
eventric.set 'store', require 'src/eventric/eventric-store-localstorage'
module.exports = _loadTodoMVC()


# node with mongo
###
module.exports = new Promise (resolve, reject) ->
  eventricStoreMongoDb = require 'eventric-store-mongodb'
  eventricStoreMongoDb.initialize ->
    eventric.set 'store', eventricStoreMongoDb
    resolve _loadTodoMVC()
###