angular.module("logbuch").controller "TrackCtrl", ($scope, $ionicScrollDelegate, $rootScope, $timeout, $log, ToastrService, StorageService, Log, DebugLog, Track, LocationService) ->
  $scope.view = StorageService.get('currentTrackView', 'track')

  $rootScope.$$listeners['locationChange'] = [] # unregister existing listeners
  $rootScope.$on 'locationChange', (event, position) ->
    return unless $scope.track
    return unless position.coords.accuracy <= 50

    new DebugLog('TrackCtrl Position Update').save()
    $scope.track.updateCurrentPosition(position)
    Track.toStorage($scope.track)

  if $scope.view == 'track'
    $scope.track = Track.fromStorage()
    LocationService.watchPosition() if $scope.track

  $scope.start = ->
    success = (position) ->
      $scope.track = Track.fromPosition(position.latLng.lat, position.latLng.lng)
      Track.toStorage($scope.track)
      ToastrService.hide()
      LocationService.watchPosition()

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getAccuratePosition().then success, error

  $scope.stop = ->
    success = (position) ->
      ToastrService.hide()
      $scope.track.addWaypoint(position.latLng.lat, position.latLng.lng)
      $scope.log = $scope.track.toLog()
      $scope.track = null
      Track.clearStorage()
      LocationService.clearWatch($scope.watcher)
      $scope.view = 'save'

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getAccuratePosition().then success, error

  $scope.cancel = ->
    $scope.view = 'track'
    $ionicScrollDelegate.scrollTop()

  $scope.waypoint = ->
    success = (position) ->
      $scope.track.addWaypoint(position.latLng.lat, position.latLng.lng)
      ToastrService.hide()

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getAccuratePosition().then success, error

  $scope.save = ->
    $scope.log.save().then ->
      $scope.view = 'track'
      $ionicScrollDelegate.scrollTop()

  # watch form
  calculate = -> $scope.log && $scope.log.calculatePoints()
  $scope.$watch 'log' , calculate, true
