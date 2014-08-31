todomvcModule.provider 'todomvc', [ ->
  todomvc = require 'src/eventric'

  $get: ->
    todomvc

]
