module.exports = ->

  handleTodoAdded: (domainEvent) ->
    @stats ?= {}
    @stats.added ?= 0

    @stats.added++

  handleTodoCompleted: ->
    @stats.completed ?= 0

    @stats.completed++

  handleTodoRemoved: ->
    @stats.removed ?= 0

    @stats.removed++