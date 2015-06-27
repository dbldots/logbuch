angular.module("logbuch").factory "LocationService", ($rootScope, $q, $log, $timeout, $ionicPlatform, $cordovaGeolocation) ->
  getPosition: ->
    deferred = $q.defer()

    success = (position) ->
      deferred.resolve(position)

    error = ->
      deferred.reject()

    $ionicPlatform.ready ->
      $cordovaGeolocation
        .getCurrentPosition(timeout: 10000, enableHighAccuracy: true)
        .then success, error

    deferred.promise

  watching: false
  watchPosition: ->
    return if @watching

    success = (position) =>
      return unless @watching
      $rootScope.$emit 'locationChange', position
      $timeout watch, 10000

    error = ->
      watch() # start over

    watch = =>
      @getPosition().then success, error

    @watching = true
    $timeout watch, 10000

  clearWatch: (watcher) ->
    @watching = false

  decimalToDms: (d) ->
    deg = d | 0 # truncate dd to get degrees
    frac = Math.abs(d - deg) # get fractional part
    min = (frac * 60) | 0 # multiply fraction by 60 and truncate
    sec = (frac * 3600 - min * 60) || 0

    deg: deg
    min: min
    sec: sec
