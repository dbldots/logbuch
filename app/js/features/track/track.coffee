angular.module("logbuch").factory "Track", (StorageService, Log) ->
  class Track
    @attributes = ['lat', 'long', 'waypoints', 'distanceKm', 'distanceNm']

    @calculateDistanceKm: (lat1, lon1, lat2, lon2) ->
      deg2rad = (deg) -> deg * (Math.PI/180)

      R = 6371 # Radius of the earth in km
      dLat = deg2rad(lat2-lat1)
      dLon = deg2rad(lon2-lon1)
      a =
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
        Math.sin(dLon/2) * Math.sin(dLon/2)

      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = R * c # Distance in km

    @convertKmtoNm = (km) ->
      parseFloat(km) * 0.539956803456

    @fromStorage = ->
      stored = StorageService.getObject('currentTrack')
      return null unless stored

      track = new Track()
      angular.forEach @attributes, (attr) ->
        track[attr] = stored[attr]

      track

    @toStorage: (track = {}) ->
      object = _.pick track, Track.attributes
      StorageService.setObject('currentTrack', object)

    @clearStorage: ->
      StorageService.clear('currentTrack')

    @fromPosition = (lat, long) ->
      track = new Track()
      track.lat = lat
      track.long = long
      track.addWaypoint(lat, long)
      track.distanceKm = 0
      track.distanceNm = 0
      track

    constructor: ->
      @waypoints = []

    addWaypoint: (lat, long, timestamp = moment().toISOString()) ->
      @waypoints.push({lat: lat, long: long, timestamp: timestamp})
      @calculateTotalDistance()
      true

    updateCurrentPosition: (lat, long) ->
      @lat = lat
      @long = long
      @calculateTotalDistance()
      @calculateCurrentDistance()
      true

    calculateCurrentDistance: ->
      reference = _.last(@waypoints)
      @distanceKm = @totalDistanceKm + Track.calculateDistanceKm(reference.lat, reference.long,  @lat, @long)
      @distanceNm = @totalDistanceNm + Track.convertKmtoNm(@distanceKm)

    calculateTotalDistance: ->
      distance = 0

      current = _.first @waypoints
      angular.forEach @waypoints, (waypoint) ->
        distance += Track.calculateDistanceKm(current.lat, current.long, waypoint.lat, waypoint.long)
        current = waypoint

      @totalDistanceKm = distance
      @totalDistanceNm = Track.convertKmtoNm(distance)

    toLog: ->
      log = new Log()
      log.type = 'inland'
      log.waypoints = @waypoints
      log.distance_km = @totalDistanceKm
      log.distance_nm = @totalDistanceNm
      log.calculatePoints()
      log
