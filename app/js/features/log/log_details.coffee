angular.module("logbuch").controller "LogDetailsCtrl", ($scope, $state, $stateParams, $filter, $ionicHistory, Log) ->
  map = plugin.google.maps.Map.getMap()

  $scope.$on '$ionicView.enter', ->
    stateChangeListener = $scope.$on '$stateChangeSuccess', (data) ->
      map.setVisible(false)
      stateChangeListener()

  Log.find($stateParams.log_id).then (log) ->
    $scope.log = log

    divMap = document.getElementById('map')

    map.clear()
    map.setDiv(divMap)
    map.setVisible(true)

    coords = []
    angular.forEach log.waypoints, (waypoint) ->
      latLng = new plugin.google.maps.LatLng(waypoint.lat, waypoint.long)

      coords.push(latLng)
      map.addMarker(
        { position: latLng, title: $filter('datetime')(waypoint.timestamp) },
        (marker) -> marker.showInfoWindow()
      )

    map.addPolyline(
      points: coords
      color: '#886aea'
      width: 4
      geodesic: true
    )

    bounds = new plugin.google.maps.LatLngBounds(coords)
    map.setCenter(bounds.getCenter())

    map.setZoom(12)

  $scope.back = ->
    $ionicHistory.nextViewOptions(
      disableAnimate: true
      disableBack: true
    )
    $state.go('tab.log')
