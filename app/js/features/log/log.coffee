angular.module("logbuch").factory "Log", (Model) ->
  class Log extends Model
    @table = 'logs'
    @columns = [
      { name: "id",          type: "integer primary key"                 }
      { name: "type",        type: "text"                                }
      { name: "engine",      type: "integer",              map: "bool"   }
      { name: "current",     type: "integer",              map: "bool"   }
      { name: "family",      type: "integer",              map: "bool"   }
      { name: "waypoints",   type: "text",                 map: "json"   }
      { name: "distance_km", type: "real"                                }
      { name: "distance_nm", type: "real"                                }
      { name: "points",      type: "integer"                             }
      { name: "comment",     type: "text"                                }
    ]

    @types = [
      'inland',
      'sea',
      'lock',
      'mast',
      'trailer',
      'distance', 'distance_plus',
      'club_trip',
      'regatta'
    ]

    calculatePoints: ->
      points = 0

      switch @type
        when 'inland'
          factor = 1
          factor = 0.2  if @engine
          factor = 3    if @current
          points = parseFloat(@distance_km) * factor

        when 'sea'
          factor = 1
          factor = 0.2  if @engine
          factor = 3    if @current
          points = parseFloat(@distance_nm) * factor

        when 'lock'           then points = 4
        when 'mast'           then points = 2
        when 'distance'       then points = 20
        when 'distance_plus'  then points = 10
        when 'trailer'        then points = 50
        when 'club_trip'      then points = 20
        when 'regatta'        then points = 25

      points = points * 2 if @family

      @points = Math.round(points || 0)

    isTrack: ->
      @type == 'inland' || @type == 'sea'

    @define 'start',
      get: -> @waypoints? && _.first(@waypoints)

    @define 'destination',
      get: -> @waypoints? && _.last(@waypoints)

    @define 'distance',
      get: ->
        @distance_nd

      set: (value) ->
        @distance_nd = value
        @distance_km = parseFloat(value) if @type == 'inland'
        @distance_nm = parseFloat(value) if @type == 'sea'
