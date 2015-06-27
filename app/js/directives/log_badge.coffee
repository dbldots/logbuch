angular.module("logbuch").directive "logBadge", ->
  restrict: "E"
  scope:
    log: '='

  link: link = (scope, element, attrs) ->
    element.append("<span class='type positive-bg'>Mast gelegt</span>")           if scope.log.type == 'mast'
    element.append("<span class='type positive-bg'>Schleuse passiert</span>")     if scope.log.type == 'lock'
    element.append("<span class='type positive-bg'>Trailertransport</span>")      if scope.log.type == 'trailer'
    element.append("<span class='type positive-bg'>Langtörn &gt; 200 km</span>")  if scope.log.type == 'distance'
    element.append("<span class='type positive-bg'>Langtörn + 100 km</span>")     if scope.log.type == 'distance_plus'
    element.append("<span class='type positive-bg'>Gemeinschaftsfahrt</span>")    if scope.log.type == 'club_trip'
    element.append("<span class='type positive-bg'>Regatta Funktion</span>")      if scope.log.type == 'regatta'

    element.append("<span class='type positive-bg'>Binnen</span>")    if scope.log.type == 'inland'
    element.append("<span class='type positive-bg'>See</span>")       if scope.log.type == 'sea'
    element.append("<span class='type positive-bg'>Familie</span>")   if scope.log.family
    element.append("<span class='type positive-bg'>Strömung</span>")  if scope.log.current
    element.append("<span class='type positive-bg'>Motor</span>")     if scope.log.engine
