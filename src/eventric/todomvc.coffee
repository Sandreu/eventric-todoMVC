eventric = require 'eventric'

_loadTodoMVC = ->
  eventric.boundedContext 'todomvc'
    .addDomainEvents require './domain/events'
    .addAggregate 'Todo', require './domain/todo'
    .addCommandHandlers require './application/commandhandlers'
    .addProjection 'Todos', require './domain/todos_projection'
    .addProjection 'TodoStats', require './domain/todo_stats_projection'


if typeof window isnt 'undefined'
  module.exports = require('./todomvc_client') _loadTodoMVC
else
  module.exports = require('./todomvc_server') _loadTodoMVC
