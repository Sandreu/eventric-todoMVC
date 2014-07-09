localstorageStore =

  save: (collectionName, doc, callback) ->
    key = "#{collectionName}.#{doc.id}"
    simpleStorage.set key, doc
    console.log 'added domainevent to localstorage', key, doc
    callback null, doc

  find: ([collectionName, query, projection]..., callback) ->
    events = []
    keys = simpleStorage.index()

    if query['aggregate.id']
      aggregateId = query['aggregate.id']

      for key in keys
        if aggregateId is key.split('.').pop()
          events.push simpleStorage.get key

    else
      for key in keys
        events.push simpleStorage.get key

    callback null, events

  collection: (collectionName, callback) ->
    callback null,
      remove: (callback) ->
        callback()


module.exports = localstorageStore