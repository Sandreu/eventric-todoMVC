describe 'eventric-todoMVC', ->
  mockTodos = [
    {
      title: "Create a TodoMVC template"
      completed: true
    }
    {
      title: "Rule the Web"
      completed: false
    }
  ]

  beforeEach angular.mock.module 'eventricTodoMVC'

  $scope = null
  controller = null
  beforeEach inject (_$rootScope_, _$controller_) ->
    $rootScope    = _$rootScope_
    $controller   = _$controller_
    $scope = $rootScope.$new()
    $scope.todos = mockTodos
    controller = $controller 'EventricTodoMVCCtrl', $scope: $scope

  describe '#addTodo', ->
    it 'should add a todo to todos list',  ->
      newTodoTitle = "Added Todo"
      $scope.newTodo = newTodoTitle
      $scope.addTodo()
      expect($scope.todos.length).to.equal 3
      expect($scope.todos[2].title).to.equal newTodoTitle
      expect($scope.todos[2].completed).not.to.be

  describe '#removeTodo', ->
    it 'should remove a todo from todos list at given index',  ->
      $scope.removeTodo 1
      expect($scope.todos.length).to.equal 1
