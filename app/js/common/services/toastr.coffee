angular.module("logbuch").factory "ToastrService", ($ionicLoading) ->
  show: (msg, stay = false) ->
    duration = 1000 unless stay
    $ionicLoading.show(template: msg, duration: duration)

  hide: ->
    $ionicLoading.hide()
