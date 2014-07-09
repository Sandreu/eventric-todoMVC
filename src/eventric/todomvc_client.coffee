eventric = require 'eventric'

module.exports = (_loadTodoMVC) ->

  #store = require 'src/eventric/eventric-store-inmemory'
  store = require 'src/eventric/eventric-store-localstorage'
  #store = require 'src/eventric/eventric-remote-store-client'

  eventric.set 'store', store

  _loadTodoMVC()