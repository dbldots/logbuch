angular.module("logbuch").filter "dms_lat3", (LocationService) ->
  (d) ->
    dir = if d < 0 then 'S' else 'N'
    dms = LocationService.decimalToDms(d)
    dms.sec = dms.sec.toFixed(3)

    "#{dms.deg}° #{dms.min}' #{dms.sec}'' #{dir}"

angular.module("logbuch").filter "dms_long3", (LocationService) ->
  (d) ->
    dir = if d < 0 then 'W' else 'E'
    dms = LocationService.decimalToDms(d)
    dms.sec = dms.sec.toFixed(3)

    "#{dms.deg}° #{dms.min}' #{dms.sec}'' #{dir}"

angular.module("logbuch").filter "dms_lat0", (LocationService) ->
  (d) ->
    dir = if d < 0 then 'S' else 'N'
    dms = LocationService.decimalToDms(d)
    dms.sec = Math.round(dms.sec)

    "#{dms.deg}° #{dms.min}' #{dms.sec}'' #{dir}"

angular.module("logbuch").filter "dms_long0", (LocationService) ->
  (d) ->
    dir = if d < 0 then 'W' else 'E'
    dms = LocationService.decimalToDms(d)
    dms.sec = Math.round(dms.sec)

    "#{dms.deg}° #{dms.min}' #{dms.sec}'' #{dir}"
