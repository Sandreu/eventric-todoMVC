var todoMVCDemoModule;

todoMVCDemoModule = angular.module("eventricTodoMVCDemo", ['eventricTodoMVC']);

todoMVCDemoModule.controller("eventricTodoMVCDemoCtrl", [
  "$scope", function($scope) {
    return $scope.moduleName = "eventric-todoMVC";
  }
]);
