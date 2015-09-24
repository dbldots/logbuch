angular.module("logbuch")

.controller "AddGpxCtrl", ($rootScope, $scope, $state, $stateParams, $filter, $timeout, Log, DebugLog, ToastrService, Track) ->
  gpx = $rootScope.importedGpx && $rootScope.importedGpx.shift()
  return $state.go('tab.track') if _.isEmpty(gpx)

  $scope.log = new Log()
  $scope.log.type = 'inland'
  $scope.log.waypoints = []

  map = L.map('mapGpxImport')

  osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors'
  osm = new L.TileLayer(osmUrl, {minZoom: 6, maxZoom: 18, attribution: osmAttrib})

  # start the map in South-East England
  map.setView(new L.LatLng(51.3, 0.7),9)
  map.addLayer(osm)

  try
    doc     = jQuery.parseXML(gpx)
    points  = []
    $(doc).find('trkpt').each (index, trkpt) ->
      trkpt = $(trkpt)
      lat   = parseFloat(trkpt.attr('lat'))
      long  = parseFloat(trkpt.attr('lon'))
      time  = trkpt.find('time').html() || moment().toISOString()

      point = L.point(lat, long)
      point.timestamp = time
      points.push(point)

    points = L.LineUtil.simplify(points, 0.0005)

    distance  = 0
    coords    = []
    current   = _.first points
    for point in points
      $scope.log.waypoints.push({lat: point.x, long: point.y, timestamp: point.timestamp})
      distance += Track.calculateDistanceKm(current.x, current.y, point.x, point.y)

      latLng  = L.latLng(current.x, current.y)
      coords.push(latLng)

      marker  = L.marker(latLng).addTo(map)
      marker.bindPopup($filter('datetime')(point.timestamp))

      current = point

    $scope.log.distance_km = distance
    $scope.log.distance_nm = Track.convertKmtoNm(distance)
    $scope.log.calculatePoints()

  catch error
    ToastrService.show('Importieren fehlgeschlagen!')
    new DebugLog('import error', error)
    return $state.go('tab.track')

  track = L.polyline(coords, color: '#886aea').addTo(map)

  bounds = L.latLngBounds(coords)
  map.fitBounds(bounds)

  $scope.save = ->
    $scope.log.save().then ->
      $state.go('tab.log')

  $scope.cancel = ->
    $state.go('tab.track')
    $ionicScrollDelegate.scrollTop()

  # watch form
  calculate = -> $scope.log && $scope.log.calculatePoints()
  $scope.$watch 'log' , calculate, true
