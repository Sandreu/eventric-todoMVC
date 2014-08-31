module.exports = ->

  create: (title, done) ->
    @$emitDomainEvent 'TodoAdded', title: title
    done()

  remove: ->
    @$emitDomainEvent 'TodoRemoved'

  complete: ->
    @$emitDomainEvent 'TodoCompleted'

  incomplete: ->
    @$emitDomainEvent 'TodoNotCompleted'

  changeTitle: (title) ->
    @$emitDomainEvent 'TodoTitleChanged', title: title
