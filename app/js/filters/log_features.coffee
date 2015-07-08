angular.module("logbuch").filter "logFeatures", ->
  (log) ->
    switch log.type
      when 'mast' then 'Mast gelegt'
      when 'lock' then 'Schleuse passiert'
      when 'trailer' then 'Trailertransport'
      when 'distance' then 'Langtörn > 200 km'
      when 'distance_plus' then 'Langtörn + 100 km'
      when 'club_trip' then 'Gemeinschaftsfahrt'
      when 'regatta' then 'Regatta Funktion'

      when 'inland'
        text = 'Binnen'
        text += ', unter Motor'     if log.engine
        text += ', starke Strömung' if log.current
        text

      when 'sea'
        text = 'See'
        text += ', unter Motor'     if log.engine
        text += ', starke Strömung' if log.current
        text
