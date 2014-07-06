var eventric, inMemoryStore, todomvcModule,
  __slice = [].slice;

eventric = require('eventric');

inMemoryStore = {
  _events: {},
  save: function(collectionName, doc, callback) {
    var _base;
    if ((_base = this._events)[collectionName] == null) {
      _base[collectionName] = [];
    }
    this._events[collectionName].push(doc);
    console.log('the events', this._events);
    return callback(null, doc);
  },
  find: function() {
    var aggregateId, callback, collectionName, events, projection, query, _arg, _i;
    _arg = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), callback = arguments[_i++];
    collectionName = _arg[0], query = _arg[1], projection = _arg[2];
    aggregateId = query['aggregate.id'];
    events = this._events[collectionName].filter(function(event) {
      return event.aggregate.id === aggregateId;
    });
    return callback(null, events);
  },
  collection: function(collectionName, callback) {
    return callback(null, []);
  }
};

eventric.set('store', inMemoryStore);

todomvcModule = angular.module('eventricTodoMVC', ['ui.router']);

todomvcModule.provider('todomvc', [
  function() {
    var todomvc, todos;
    todomvc = eventric.boundedContext('todomvc');
    todos = [];
    todomvc.addDomainEvents({
      TodoAdded: function(params) {
        this.title = params.title;
        return this.completed = false;
      },
      TodoRemoved: function() {
        return this.removed = true;
      },
      TodoCompleted: function() {
        return this.completed = true;
      },
      TodoNotCompleted: function() {
        return this.completed = false;
      }
    });
    todomvc.addAggregate('Todo', function() {
      return {
        create: function(params) {
          return this.$emitDomainEvent('TodoAdded', {
            title: params.title
          });
        },
        remove: function() {
          return this.$emitDomainEvent('TodoRemoved');
        },
        complete: function() {
          return this.$emitDomainEvent('TodoCompleted');
        },
        incomplete: function() {
          return this.$emitDomainEvent('TodoNotCompleted');
        },
        handleTodoAdded: function() {},
        handleTodoRemoved: function() {},
        handleTodoCompleted: function() {},
        handleTodoNotCompleted: function() {}
      };
    });
    todomvc.addCommandHandlers({
      AddTodo: function(params, callback) {
        return this.$aggregate.create({
          name: 'Todo',
          props: params
        }).then(function(todoId) {
          return callback(null, todoId);
        });
      },
      RemoveTodo: function(params, callback) {
        return this.$aggregate.command({
          name: 'Todo',
          id: params.id,
          methodName: 'remove'
        }).then(function() {
          return callback(null, null);
        });
      },
      CompleteTodo: function(params, callback) {
        return this.$aggregate.command({
          name: 'Todo',
          id: params.id,
          methodName: 'complete'
        }).then(function() {
          return callback(null, null);
        });
      },
      IncompleteTodo: function(params, callback) {
        return this.$aggregate.command({
          name: 'Todo',
          id: params.id,
          methodName: 'incomplete'
        }).then(function() {
          return callback(null, null);
        });
      }
    });
    todomvc.addReadModel('Todos', function() {
      return {
        subscribeToDomainEvents: ['TodoAdded', 'TodoRemoved', 'TodoCompleted', 'TodoNotCompleted'],
        handleTodoCompleted: function(domainEvent) {
          return todos.map(function(todo) {
            if (todo.id === domainEvent.aggregate.id) {
              return todo.completed = true;
            }
          });
        },
        handleTodoRemoved: function(domainEvent) {
          return todos = todos.filter(function(todo) {
            return todo.id !== domainEvent.aggregate.id;
          });
        },
        handleTodoNotCompleted: function(domainEvent) {
          return todos.map(function(todo) {
            if (todo.id === domainEvent.aggregate.id) {
              return todo.completed = false;
            }
          });
        },
        handleTodoAdded: function(domainEvent) {
          var todo;
          todo = {
            id: domainEvent.aggregate.id,
            title: domainEvent.payload.title,
            completed: domainEvent.payload.completed
          };
          return todos.push(todo);
        }
      };
    });
    todomvc.initialize();
    return {
      $get: [
        "$rootScope", function($rootScope) {
          return {
            completeTodo: function(id) {
              return todomvc.command({
                name: 'CompleteTodo',
                params: {
                  id: id
                }
              }).then(function() {
                return $rootScope.$apply();
              });
            },
            incompleteTodo: function(id) {
              return todomvc.command({
                name: 'IncompleteTodo',
                params: {
                  id: id
                }
              }).then(function() {
                return $rootScope.$apply();
              });
            },
            addTodo: function(title) {
              return todomvc.command({
                name: 'AddTodo',
                params: {
                  title: title
                }
              }).then(function() {
                return $rootScope.$apply();
              });
            },
            removeTodo: function(id) {
              return todomvc.command({
                name: 'RemoveTodo',
                params: {
                  id: id
                }
              }).then(function() {
                return $rootScope.$apply();
              });
            },
            getTodos: function() {
              return todos;
            }
          };
        }
      ]
    };
  }
]);

todomvcModule.controller("EventricTodoMVCCtrl", [
  "$scope", "$filter", "$timeout", "todomvc", function($scope, $filter, $timeout, todomvc) {
    $scope.remainingCount = 0;
    $scope.status = '';
    $scope.todos = [];
    todomvc.addTodo('Create a TodoMVC template');
    todomvc.addTodo('Rule the web');
    $scope.addTodo = function() {
      todomvc.addTodo($scope.newTodo);
      return $scope.newTodo = '';
    };
    $scope.setCompleteStatus = function(todo) {
      if (todo.completed) {
        return todomvc.completeTodo(todo.id);
      } else {
        return todomvc.incompleteTodo(todo.id);
      }
    };
    $scope.removeTodo = function(todo) {
      return todomvc.removeTodo(todo.id);
    };
    $scope.clearCompleted = function() {
      var todo, _i, _len, _ref, _results;
      _ref = $filter('filter')($scope.todos, {
        completed: true
      });
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        todo = _ref[_i];
        _results.push(todomvc.removeTodo(todo.id));
      }
      return _results;
    };
    $scope.$watch(function() {
      return todomvc.getTodos();
    }, function(todos) {
      var remaining;
      console.log('todos', todos);
      $scope.todos = angular.copy(todos);
      remaining = $filter('filter')($scope.todos, {
        completed: false
      });
      $scope.remainingCount = remaining.length;
      return $scope.completedCount = $scope.todos.length - $scope.remainingCount;
    }, true);
    return this;
  }
]);
