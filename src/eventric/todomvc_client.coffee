eventric = require 'eventric'

module.exports = (_loadTodoMVC) ->
  #eventric.set 'store', require 'src/eventric/eventric-store-inmemory'
  #eventric.set 'store', require 'src/eventric/eventric-store-localstorage'
  eventric.set 'store', require 'src/eventric/eventric-remote-store-client'

  _loadTodoMVC()