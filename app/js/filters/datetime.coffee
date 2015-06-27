moment.locale('de')

angular.module("logbuch")

.filter "datetime", ->
  (date) ->
    moment(date).format('dd, DD.MM. HH:mm')
