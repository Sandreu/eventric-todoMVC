todomvcModule = angular.module 'eventricTodoMVC', ['ui.router']

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