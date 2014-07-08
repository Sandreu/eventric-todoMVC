require('coffee-script/register');
require('src/eventric/todomvc').then(function(_todomvc) {
  todomvc = _todomvc
  todomvc.command({
    name: 'AddTodo',
    params: {
      title: 'Enjoy MNUG'
    }
  }).then(function(todoId) {
    return todomvc.command({
      name: 'ChangeTodoTitle',
      params: {
        id: todoId,
        title: 'Enjoy MNUG!'
      }
    })
  }).then(function() {
    todomvc.getProjection('Todos').todos;
  })
});
