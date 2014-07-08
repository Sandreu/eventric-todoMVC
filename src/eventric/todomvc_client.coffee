eventric = require 'eventric'



class RemoteStoreClient

  constructor: ->
    @_callbacks = {}

    @socket = io('http://localhost:3000')

  save: (collectionName, doc, callback) ->
    guid = eventric.generateUid()

    console.log 'trying remote save', guid
    @socket.on "RemoteStore:save:#{guid}", =>
      callback()

    @socket.emit 'RemoteStore:save',
      guid: guid
      collectionName: collectionName
      doc: doc


  find: ([collectionName, query, projection]..., callback) ->
    guid = eventric.generateUid()

    console.log 'trying remote find', guid
    @socket.on "RemoteStore:find:#{guid}", (data) =>
      console.log 'received find result', data.result
      callback null, data.result

    @socket.emit 'RemoteStore:find',
      guid: guid
      collectionName: collectionName
      query: query
      projection: projection


  collection: (collectionName, callback) ->
    callback null, []



module.exports = (_loadTodoMVC) ->
  #eventric.set 'store', require 'src/eventric/eventric-store-inmemory'
  #eventric.set 'store', require 'src/eventric/eventric-store-localstorage'
  eventric.set 'store', new RemoteStoreClient

  _loadTodoMVC()