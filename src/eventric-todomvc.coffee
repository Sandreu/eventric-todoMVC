eventric = require 'eventric'

inMemoryStore =
  _events: {}

  save: (collectionName, doc, callback) ->
    @_events[collectionName] ?= []
    @_events[collectionName].push doc
    console.log 'the events', @_events
    callback null, doc

  find: ([collectionName, query, projection]..., callback) ->
    aggregateId = query['aggregate.id']

    events = @_events[collectionName].filter (event) ->
      event.aggregate.id == aggregateId

    callback null, events

  collection: (collectionName, callback) ->
    callback null, []


eventric.set 'store', inMemoryStore


todomvcModule = angular.module 'eventricTodoMVC', ['ui.router']

todomvcModule.provider 'todomvc', [ ->
  todomvc = eventric.boundedContext 'todomvc'
  todos = []

  todomvc.addDomainEvents
    TodoAdded: (params) ->
      @title = params.title
      @completed = false

    TodoRemoved: ->
      @removed = true

    TodoCompleted: ->
      @completed = true

    TodoNotCompleted: ->
      @completed = false


  todomvc.addAggregate 'Todo', ->
    create: (params) ->
      @$emitDomainEvent 'TodoAdded', title: params.title

    remove: ->
      @$emitDomainEvent 'TodoRemoved'

    complete: ->
      @$emitDomainEvent 'TodoCompleted'

    incomplete: ->
      @$emitDomainEvent 'TodoNotCompleted'

    handleTodoAdded: ->

    handleTodoRemoved: ->

    handleTodoCompleted: ->

    handleTodoNotCompleted: ->


  todomvc.addCommandHandlers
    AddTodo: (params, callback) ->
      @$aggregate.create
        name: 'Todo'
        props: params
      .then (todoId) ->
        callback null, todoId

    RemoveTodo: (params, callback) ->
      @$aggregate.command
        name: 'Todo'
        id: params.id
        methodName: 'remove'
      .then ->
        callback null, null

    CompleteTodo: (params, callback) ->
      @$aggregate.command
        name: 'Todo'
        id: params.id
        methodName: 'complete'
      .then ->
        callback null, null

    IncompleteTodo: (params, callback) ->
      @$aggregate.command
        name: 'Todo'
        id: params.id
        methodName: 'incomplete'
      .then ->
        callback null, null


  todomvc.addReadModel 'Todos', ->
    subscribeToDomainEvents: [
      'TodoAdded'
      'TodoRemoved'
      'TodoCompleted'
      'TodoNotCompleted'
    ]
    handleTodoCompleted: (domainEvent) ->
      todos.map (todo) ->
        if todo.id == domainEvent.aggregate.id
          todo.completed = true

    handleTodoRemoved: (domainEvent) ->
      todos = todos.filter (todo) ->
        todo.id != domainEvent.aggregate.id

    handleTodoNotCompleted: (domainEvent) ->
      todos.map (todo) ->
        if todo.id == domainEvent.aggregate.id
          todo.completed = false

    handleTodoAdded: (domainEvent) ->
      todo =
        id: domainEvent.aggregate.id
        title: domainEvent.payload.title
        completed: domainEvent.payload.completed

      todos.push todo


  todomvc.initialize()

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
      .then ->
        $rootScope.$apply()

    removeTodo: (id) ->
      todomvc.command
        name: 'RemoveTodo'
        params:
          id: id
      .then ->
        $rootScope.$apply()

    getTodos: ->
      todos
  ]
]

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter", "$timeout", "todomvc"
  ($scope, $filter, $timeout, todomvc) ->

    $scope.remainingCount = 0
    $scope.status = ''

    $scope.todos = []


    todomvc.addTodo 'Create a TodoMVC template'
    todomvc.addTodo 'Rule the web'


    $scope.addTodo = ->
      todomvc.addTodo $scope.newTodo
      $scope.newTodo = ''

    $scope.setCompleteStatus = (todo) ->
      if todo.completed
        todomvc.completeTodo todo.id
      else
        todomvc.incompleteTodo todo.id

    $scope.removeTodo = (todo) ->
      todomvc.removeTodo todo.id

    $scope.clearCompleted = ->
      for todo in $filter('filter')($scope.todos, completed: true)
        todomvc.removeTodo todo.id


    $scope.$watch ->
      todomvc.getTodos()
    , (todos) ->
      console.log 'todos', todos
      $scope.todos = angular.copy todos

      remaining = $filter('filter')($scope.todos, completed: false)
      $scope.remainingCount = remaining.length
      $scope.completedCount = $scope.todos.length - $scope.remainingCount
    , true

    @
]
