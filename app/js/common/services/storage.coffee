angular.module("logbuch")

.factory "StorageService", ($window) ->
  set: (key, value) ->
    $window.localStorage[key] = value

  get: (key, defaultValue) ->
    $window.localStorage[key] || defaultValue

  setObject: (key, value) ->
    $window.localStorage[key] = JSON.stringify(value)

  getObject: (key) ->
    value = $window.localStorage[key]
    value && JSON.parse(value)

  clear: (key) ->
    $window.localStorage.removeItem(key)
