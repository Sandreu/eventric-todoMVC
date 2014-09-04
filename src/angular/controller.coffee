require 'angular'

todomvcModule = angular.module 'eventricTodoMVC', [
  require 'angular-ui-router'
]

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter", "$timeout"
  ($scope, $filter, $timeout) ->
    $scope.remainingCount = 0
    $scope.status = ''
    $scope.todos = []

    todomvc = null
    require 'src/eventric'
    .then (_todomvc) ->
      todomvc = _todomvc
      updateScope = (event) ->
        $scope.todos = event.projection.todos

        remaining = $filter('filter')($scope.todos, completed: false)
        $scope.remainingCount = remaining.length
        $scope.completedCount = $scope.todos.length - $scope.remainingCount

        $scope.$apply()

      todomvc.subscribe 'projection:Todos:initialized', (event) ->
        updateScope event
        if event.projection.todos.length is 0
          todomvc.command 'AddTodo', title: 'Create a TodoMVC template'
          .then (todoId) ->
            todomvc.command 'CompleteTodo', id: todoId
          .then ->
            todomvc.command 'AddTodo', title: 'Rule the web'

      todomvc.subscribe 'projection:Todos:changed', updateScope

      todomvc.initialize()


    $scope.addTodo = ->
      todomvc.command 'AddTodo', title: $scope.newTodo
      $scope.newTodo = ''

    $scope.setCompleteStatus = (todo) ->
      if todo.completed
        todomvc.command 'CompleteTodo', id: todo.id
      else
        todomvc.command 'IncompleteTodo', id: todo.id

    $scope.removeTodo = (todo) ->
      todomvc.command 'RemoveTodo', id: todo.id

    $scope.clearCompleted = ->
      for todo in $filter('filter')($scope.todos, completed: true)
        todomvc.command 'RemoveTodo', id: todo.id

    @
]