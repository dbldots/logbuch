angular.module("logbuch").controller "LogDetailsCtrl", ($scope, $stateParams, Log) ->
  Log.find($stateParams.log_id).then (log) ->
    $scope.log = log

    divMap = document.getElementById('map')

    map = plugin.google.maps.Map.getMap()
    map.clear()
    map.setDiv(divMap)

    coords = []
    angular.forEach log.waypoints, (waypoint) ->
      coords.push new plugin.google.maps.LatLng(waypoint.lat, waypoint.long)

    map.addPolyline(
      points: coords
      color: '#886aea'
      width: 4
      geodesic: true
    )

    bounds = new plugin.google.maps.LatLngBounds(coords)
    map.setCenter(bounds.getCenter())

    map.setZoom(12)
