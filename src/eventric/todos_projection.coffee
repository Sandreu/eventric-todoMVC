module.exports = ->
  todos: []

  handleTodoAdded: (domainEvent) ->
    todo =
      id: domainEvent.aggregate.id
      title: domainEvent.payload.title
      completed: domainEvent.payload.completed
    @todos.push todo


  handleTodoCompleted: (domainEvent) ->
    @todos.map (todo) ->
      if todo.id == domainEvent.aggregate.id
        todo.completed = true


  handleTodoRemoved: (domainEvent) ->
    @todos = @todos.filter (todo) ->
      todo.id != domainEvent.aggregate.id


  handleTodoNotCompleted: (domainEvent) ->
    @todos.map (todo) ->
      if todo.id == domainEvent.aggregate.id
        todo.completed = false


  handleTodoTitleChanged: (domainEvent) ->
    @todos.map (todo) ->
      if todo.id == domainEvent.aggregate.id
        todo.title = domainEvent.payload.title
