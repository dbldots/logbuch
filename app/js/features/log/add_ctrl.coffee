angular.module("logbuch")

.controller "AddCtrl", ($scope, $state, Log, ToastrService, LocationService) ->
  $scope.log = new Log()
  $scope.log.type = _.last($state.current.url.split('/'))

  isTrack = $scope.log.type == 'track'

  $scope.save = ->
    success = (position) ->
      ToastrService.hide()
      $scope.log.waypoints = [
        lat: position.latLng.lat
        long: position.latLng.lng
        timestamp: moment().toISOString()
      ]
      $scope.log.calculatePoints()

      $scope.log.save().then ->
        $state.go('tab.add')

    error = ->
      ToastrService.show('Ermitteln der Koordinaten fehlgeschlagen.')

    ToastrService.show('Ermittle Koordinaten...', true)
    LocationService.getAccuratePosition().then success, error

  if isTrack
    $scope.log.type = 'inland'
    calculate = -> $scope.log && $scope.log.calculatePoints()
    $scope.$watch 'log' , calculate, true
