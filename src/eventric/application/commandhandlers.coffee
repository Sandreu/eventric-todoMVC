module.exports =

  AddTodo: (params, done) ->
    @$repository('Todo').create params
    .then (todoId) =>
      return @$repository('Todo').save todoId
    .then =>
      done()


  RemoveTodo: (params, done) ->
    @$repository('Todo').findById params.id
    .then (todo) =>
      todo.remove()
      @$repository('Todo').save params.id
    .then =>
      done()


  CompleteTodo: (params, done) ->
    @$repository('Todo').findById params.id
    .then (todo) =>
      todo.complete()
      @$repository('Todo').save params.id
    .then =>
      done()


  IncompleteTodo: (params, done) ->
    @$repository('Todo').findById params.id
    .then (todo) =>
      todo.incomplete()
      @$repository('Todo').save params.id
    .then =>
      done()