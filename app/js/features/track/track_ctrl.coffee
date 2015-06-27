angular.module("logbuch").controller "TrackCtrl", ($scope, $ionicScrollDelegate, $rootScope, $timeout, $log, ToastrService, StorageService, Log, DebugLog, Track, LocationService) ->
  $scope.view = StorageService.get('currentTrackView', 'track')

  $rootScope.$$listeners['locationChange'] = [] # unregister existing listeners
  $rootScope.$on 'locationChange', (event, position) ->
    $log.info 'got position update', position, moment().toISOString()
    return unless $scope.track

    new DebugLog("updating position. lat: #{position.coords.latitude} long: #{position.coords.longitude}").save()
    $scope.track.updateCurrentPosition(position.coords.latitude, position.coords.longitude)
    Track.toStorage($scope.track)

  if $scope.view == 'track'
    $scope.track = Track.fromStorage()
    LocationService.watchPosition() if $scope.track

  $scope.start = ->
    success = (position) ->
      $scope.track = Track.fromPosition(position.coords.latitude, position.coords.longitude)
      Track.toStorage($scope.track)
      ToastrService.hide()
      LocationService.watchPosition()

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getPosition().then success, error

  $scope.stop = ->
    $scope.track.addWaypoint($scope.track.lat, $scope.track.long)
    $scope.log = $scope.track.toLog()
    $scope.track = null
    Track.clearStorage()
    LocationService.clearWatch($scope.watcher)
    $scope.view = 'save'

  $scope.cancel = ->
    $scope.view = 'track'

  $scope.waypoint = ->
    success = (position) ->
      $scope.track.addWaypoint(position.coords.latitude, position.coords.longitude)
      ToastrService.hide()

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getPosition().then success, error

  $scope.save = ->
    $scope.log.save().then ->
      $scope.view = 'track'
      $ionicScrollDelegate.scrollTop()

  # watch form
  calculate = -> $scope.log && $scope.log.calculatePoints()
  $scope.$watch 'log' , calculate, true
