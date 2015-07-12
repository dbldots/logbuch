angular.module("logbuch").factory "LocationService", ($rootScope, $q, $log, $timeout, $ionicPlatform, $cordovaGeolocation) ->
  getPosition: ->
    deferred = $q.defer()

    $ionicPlatform.ready ->
      try
        success = (location) -> deferred.resolve(location)
        error   = -> deferred.reject()

        plugin.google.maps.Map.getMap().getMyLocation success, error
      catch
        deferred.reject()

    deferred.promise

  getAccuratePosition: ->
    deferred = $q.defer()
    times = 3
    runner = 0
    bounds = new plugin.google.maps.LatLngBounds()

    error = ->
      deferred.reject()

    success = (position) ->
      bounds.extend(position.latLng)

      if runner == times
        deferred.resolve(latLng: bounds.getCenter())
      else
        $timeout run, 1500

    run = =>
      runner += 1
      @getPosition().then success.bind(@), error

    run()
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

    deg = deg * -1 if deg < 0

    deg: deg
    min: min
    sec: sec

