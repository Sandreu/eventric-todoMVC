todomvcModule = angular.module 'eventricTodoMVC', []

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter",
  ($scope, $filter) ->
    $scope.remainingCount = 0
    $scope.status = ''

    $scope.todos = [
      {
        title: "Create a TodoMVC template"
        completed: true
      }
      {
        title: "Rule the Web"
        completed: false
      }
    ]

    @_getRemaining = ->
      $filter('filter')($scope.todos, completed: false)

    $scope.addTodo = ->
      $scope.todos.push
        title: $scope.newTodo
        completed: false

      $scope.newTodo = ''


    $scope.removeTodo = (index) ->
      $scope.todos.splice index, 1

    $scope.clearCompleted = =>
      $scope.todos = @_getRemaining()

    $scope.$watch 'todos', =>
      remaining = @_getRemaining()
      $scope.remainingCount = remaining.length
      $scope.completedCount = $scope.todos.length - $scope.remainingCount
    , true

    @
]
