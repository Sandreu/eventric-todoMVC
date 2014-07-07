module.exports =

  AddTodo: (params, callback) ->
    @$aggregate.create
      name: 'Todo'
      props: params
    .then (todoId) ->
      callback null, todoId


  RemoveTodo: (params, callback) ->
    @$aggregate.command
      name: 'Todo'
      id: params.id
      methodName: 'remove'
    .then ->
      callback null, null


  CompleteTodo: (params, callback) ->
    @$aggregate.command
      name: 'Todo'
      id: params.id
      methodName: 'complete'
    .then ->
      callback null, null


  IncompleteTodo: (params, callback) ->
    @$aggregate.command
      name: 'Todo'
      id: params.id
      methodName: 'incomplete'
    .then ->
      callback null, null