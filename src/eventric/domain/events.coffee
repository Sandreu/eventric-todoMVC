module.exports =

  TodoAdded: (params) ->
    @title = params.title
    @completed = false


  TodoRemoved: ->
    @removed = true


  TodoCompleted: ->
    @completed = true


  TodoNotCompleted: ->
    @completed = false