todomvcModule = angular.module 'eventricTodoMVC', ['ui.router']

todomvcModule.controller "EventricTodoMVCCtrl", ["$scope", "$filter", "$timeout", "todomvc"
  ($scope, $filter, $timeout, todomvc) ->
    $scope.remainingCount = 0
    $scope.status = ''
    $scope.todos = []

    todomvc.getBoundedContext().initialize =>
      store = todomvc.getStore()

      if store.socket
        store.socket.on 'DomainEvent', (domainEvent) ->
          todomvc.getEventBus().publishDomainEvent domainEvent
          $scope.$apply()

      store.find 'todomvc.events', {}, (err, result) ->
        if result.length is 0
          # initial
          todomvc.addTodo 'Create a TodoMVC template'
          .then (todoId) =>
            console.log 'saved', todoId
            todomvc.completeTodo todoId
            $scope.$apply()
          todomvc.addTodo 'Rule the web'
          .then (todoId) =>
            $scope.$apply()


      $scope.$watch ->
        todomvc.getTodos()
      , (todos) ->
        $scope.todos = angular.copy todos

        remaining = $filter('filter')($scope.todos, completed: false)
        $scope.remainingCount = remaining.length
        $scope.completedCount = $scope.todos.length - $scope.remainingCount
      , true

      $timeout =>
        $scope.$apply




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

    @
]