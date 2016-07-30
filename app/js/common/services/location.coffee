angular.module("logbuch").factory "LocationService", ($rootScope, $q, $log, $timeout, $ionicPlatform, $cordovaGeolocation, DebugLog) ->
  getPosition: ->
    deferred = $q.defer()

    $ionicPlatform.ready ->
      posOptions = { timeout: 10000, enableHighAccuracy: true }
      $cordovaGeolocation.getCurrentPosition(posOptions).then (position) ->
        position.latLng = L.latLng(position.coords.latitude, position.coords.longitude)

        debug = """
          latitude: #{position.coords.latitude},
          longitude: #{position.coords.longitude},
          speed: #{position.coords.speed},
          accuracy: #{position.coords.accuracy}
        """
        new DebugLog('getPosition Result', debug).save()
        deferred.resolve(position)

      , (error) ->
        new DebugLog('getPosition Geolocation Error', error).save()
        deferred.reject(error)

    deferred.promise

  getAccuratePosition: ->
    deferred = $q.defer()
    times = 5
    runner = -1
    stack = []
    limits = [100, 80, 60, 40, 40]

    error = ->
      deferred.reject()

    success = (position) ->
      if position.coords.accuracy <= 15
        deferred.resolve(position)
        return

      if runner == times
        if stack.length == 0
          new DebugLog("GPS info not accurate. aborting").save()
          deferred.reject()
        else
          bounds = L.latLngBounds(stack)
          deferred.resolve(latLng: bounds.getCenter())

      else
        stack.push(position.latLng) if position.coords.accuracy <= limits[runner]
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

