describe 'eventric-todoMVC', ->
  beforeEach angular.mock.module 'eventricTodoMVC'

  $scope = null
  controller = null
  beforeEach inject (_$rootScope_, _$controller_) ->
    $rootScope    = _$rootScope_
    $controller   = _$controller_
    $scope = $rootScope.$new()
    controller = $controller 'EventricTodoMVCCtrl', $scope: $scope

  describe '#addTodo', ->
    it 'should add a todo to todos list',  ->
      newTodoTitle = "Added Todo"
      $scope.newTodo = newTodoTitle
      $scope.addTodo()
      expect($scope.todos.length).to.equal 1
      expect($scope.todos[0].title).to.equal newTodoTitle
      expect($scope.todos[0].completed).not.to.be

  describe '#removeTodo', ->
    it 'should remove a todo from todos list at given index',  ->
      $scope.removeTodo 0
      expect($scope.todos.length).to.equal 0
