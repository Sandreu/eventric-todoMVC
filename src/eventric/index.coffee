eventric = require 'eventric'
eventric.log.setLogLevel 'debug'

_loadTodoMVC = ->
  eventric.context 'todomvc'
    .defineDomainEvents require './domain_event_definitions'
    .addAggregate 'Todo', require './todo_aggregate'
    .addCommandHandlers require './command_handlers'
    .addProjection 'Todos', require './todos_projection'
    .addProjection 'TodoStats', require './todo_stats_projection'


if typeof window isnt 'undefined'
  module.exports = require('./index.client') _loadTodoMVC
else
  module.exports = require('./index.server') _loadTodoMVC
