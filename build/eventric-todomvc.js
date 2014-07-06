var todomvcModule;

todomvcModule = angular.module('eventricTodoMVC', []);

todomvcModule.controller("EventricTodoMVCCtrl", [
  "$scope", "$filter", function($scope, $filter) {
    $scope.remainingCount = 0;
    $scope.status = '';
    $scope.todos = [
      {
        title: "Create a TodoMVC template",
        completed: true
      }, {
        title: "Rule the Web",
        completed: false
      }
    ];
    this._getRemaining = function() {
      return $filter('filter')($scope.todos, {
        completed: false
      });
    };
    $scope.addTodo = function() {
      $scope.todos.push({
        title: $scope.newTodo,
        completed: false
      });
      return $scope.newTodo = '';
    };
    $scope.removeTodo = function(index) {
      return $scope.todos.splice(index, 1);
    };
    $scope.clearCompleted = (function(_this) {
      return function() {
        return $scope.todos = _this._getRemaining();
      };
    })(this);
    $scope.$watch('todos', (function(_this) {
      return function() {
        var remaining;
        remaining = _this._getRemaining();
        $scope.remainingCount = remaining.length;
        return $scope.completedCount = $scope.todos.length - $scope.remainingCount;
      };
    })(this), true);
    return this;
  }
]);
