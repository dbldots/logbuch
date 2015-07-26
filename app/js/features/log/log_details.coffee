angular.module("logbuch").controller "LogDetailsCtrl", ($scope, $state, $stateParams, $filter, $ionicHistory, Log) ->
  map = L.map('map')

  osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
  osm = new L.TileLayer(osmUrl, {minZoom: 8, maxZoom: 18, attribution: osmAttrib})

  #// start the map in South-East England
  map.setView(new L.LatLng(51.3, 0.7),9)
  map.addLayer(osm)

  Log.find($stateParams.log_id).then (log) ->
    $scope.log = log

    coords = []
    angular.forEach log.waypoints, (waypoint) ->
      latLng = L.latLng(waypoint.lat, waypoint.long)

      coords.push(latLng)
      marker = L.marker(latLng).addTo(map)
      marker.bindPopup($filter('datetime')(waypoint.timestamp))

    track = L.polyline(coords, color: '#886aea').addTo(map)

    bounds = L.latLngBounds(coords)
    map.fitBounds(bounds)
