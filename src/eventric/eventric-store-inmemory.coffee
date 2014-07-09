inMemoryStore =
  _events: {}

  save: (collectionName, doc, callback) ->
    @_events[collectionName] ?= []
    @_events[collectionName].push doc
    console.log 'the events', @_events
    callback null, doc

  find: ([collectionName, query, projection]..., callback) ->
    events = []
    @_events[collectionName] ?= []

    if query['aggregate.id']
      aggregateId = query['aggregate.id']

      events = @_events[collectionName].filter (event) ->
        event.aggregate.id == aggregateId

    else
      events = @_events[collectionName]

    callback null, events


  collection: (collectionName, callback) ->
    callback null,
      remove: (callback) ->
        callback()


module.exports = inMemoryStore