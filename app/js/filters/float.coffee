angular.module("logbuch")

.filter "float2", ->
  (value) ->
    parseFloat(value).toFixed(2)

.filter "float3", ->
  (value) ->
    parseFloat(value).toFixed(3)

.filter "round", ->
  (value) ->
    parseFloat(value).toFixed()
