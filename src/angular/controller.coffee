todomvcModule = angular.module 'eventricTodoMVC', ['ui.router']

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter", "$timeout", "todomvc"
  ($scope, $filter, $timeout, todomvc) ->
    $scope.remainingCount = 0
    $scope.status = ''
    $scope.todos = []

    keys = simpleStorage.index()

    if keys.length is 0
      # initial
      todomvc.addTodo 'Create a TodoMVC template'
      .then (todoId) =>
        todomvc.completeTodo todoId
        $scope.$apply()
      todomvc.addTodo 'Rule the web'
      .then (todoId) =>
        $scope.$apply()

    else
      # loading from localstorage
      eventbus = todomvc.getEventBus()
      for key in keys
        domainEvent = simpleStorage.get key
        eventbus.publishDomainEvent domainEvent


    $scope.addTodo = ->
      todomvc.addTodo $scope.newTodo
      .then =>
        $scope.$apply()

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