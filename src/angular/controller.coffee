todomvcModule = angular.module 'eventricTodoMVC', ['ui.router']

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter", "$timeout", "todomvc"
  ($scope, $filter, $timeout, todomvc) ->
    $scope.remainingCount = 0
    $scope.status = ''
    $scope.todos = []


    todomvc.initialize =>

      todomvc.subscribeToAllDomainEvents ->
        $timeout ->
          $scope.$apply()
        , 100

      todomvc.getDomainEventsStore().findAllDomainEvents (err, result) ->
        if result.length > 0
          return

        # Create initial todos if there are no todos in the store
        todomvc.command 'AddTodo', title: 'Create a TodoMVC template'
        .then (todoId) ->
          todomvc.command 'CompleteTodo', id: todoId
        .then ->
          todomvc.command 'AddTodo', title: 'Rule the web'
        .then ->
          # TODO: use changed event from projection instead of timeout
          $timeout ->
            $scope.$apply()
          , 100


      # TODO: use changed event from projection instead of this hackery
      $scope.$watch ->
        todomvc.getProjection('Todos').todos
      , (todos) ->
        $scope.todos = angular.copy todos

        remaining = $filter('filter')($scope.todos, completed: false)
        $scope.remainingCount = remaining.length
        $scope.completedCount = $scope.todos.length - $scope.remainingCount

        $timeout ->
          $scope.$apply()



    $scope.addTodo = ->
      todomvc.command 'AddTodo', title: $scope.newTodo
      .then ->
        $scope.$apply()

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