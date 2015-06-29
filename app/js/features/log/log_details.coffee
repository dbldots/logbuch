angular.module("logbuch").controller "LogDetailsCtrl", ($scope, $stateParams, Log) ->
  Log.find($stateParams.log_id).then (log) ->
    $scope.log = log

    startLatLng = new google.maps.LatLng(log.start.lat, log.start.long)
    mapOptions =
      center: startLatLng
      zoom: 16
      mapTypeId: google.maps.MapTypeId.ROADMAP
 
    map = new google.maps.Map(document.getElementById("map"), mapOptions)

    coords = []
    angular.forEach log.waypoints, (waypoint) ->
      coords.push new google.maps.LatLng(waypoint.lat, waypoint.long)

    path = new google.maps.Polyline(
      path: coords
      geodesic: true
      strokeColor: '#886aea'
      strokeOpacity: 0.7
      strokeWeight: 3
    )

    path.setMap(map)

    bounds = new google.maps.LatLngBounds()
    angular.forEach coords, (coord) ->
      bounds.extend(coord)

    map.setCenter(bounds.getCenter())
    map.fitBounds(bounds)

    map.setZoom(map.getZoom()-1)

    if (map.getZoom() > 17)
      map.setZoom(17)
