localstorageStore =

  save: (collectionName, doc, callback) ->
    key = "#{collectionName}.#{doc.id}"
    simpleStorage.set key, doc
    console.log 'added domainevent to localstorage', key, doc
    callback null, doc

  find: ([collectionName, query, projection]..., callback) ->
    aggregateId = query['aggregate.id']
    console.log aggregateId
    events = []
    keys = simpleStorage.index()

    for key in keys
      if aggregateId is key.split('.').pop()
        console.log 'wat', id
        events.push simpleStorage.get key
        console.log 'wat', events


    callback null, events

  collection: (collectionName, callback) ->
    callback null,
      remove: (callback) ->
        callback()


module.exports = localstorageStore