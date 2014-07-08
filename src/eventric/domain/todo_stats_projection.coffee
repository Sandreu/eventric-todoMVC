module.exports = ->

  stats: {}

  handleTodoAdded: ->
    if not @stats.added
      @stats.added = 0

    @stats.added++

  handleTodoCompleted: ->
    if not @stats.completed
      @stats.completed = 0

    @stats.completed++

  handleTodoRemoved: ->
    if not @stats.removed
      @stats.removed = 0

    @stats.removed++