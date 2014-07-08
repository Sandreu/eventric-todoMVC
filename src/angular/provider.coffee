todomvcModule.provider 'todomvc', [ ->
  todomvc = require 'src/eventric/todomvc'

  $get: ["$rootScope", ($rootScope) ->
    completeTodo: (id) ->
      todomvc.command
        name: 'CompleteTodo'
        params:
          id: id
      .then ->
        $rootScope.$apply()

    incompleteTodo: (id) ->
      todomvc.command
        name: 'IncompleteTodo'
        params:
          id: id
      .then ->
        $rootScope.$apply()

    addTodo: (title) ->
      todomvc.command
        name: 'AddTodo'
        params:
          title: title

    removeTodo: (id) ->
      todomvc.command
        name: 'RemoveTodo'
        params:
          id: id
      .then ->
        $rootScope.$apply()

    changeTodoTitle: (id, title) ->
      todomvc.command
        name: 'ChangeTodoTitle'
        params:
          id: id
          title: title
      .then ->
        $rootScope.$apply()

    getTodos: ->
      todoProjection = todomvc.getProjection 'Todos'
      todoProjection.todos

    getEventBus: ->
      todomvc.getEventBus()
  ]

]
