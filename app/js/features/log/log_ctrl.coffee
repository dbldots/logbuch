angular.module("logbuch")

.controller "LogCtrl", ($scope, $stateParams, $ionicPopup, $timeout, Log, ToastrService) ->
  query = ->
    Log.all('id DESC').then (logs) ->
      $scope.logs = logs
      $scope.total = _.sum logs, 'points'

  # touch + released is a workaround since on-hold does not work with android
  released = null
  $scope.touch = (log) ->
    released = null

    $timeout ->
      $scope.delete(log) unless released
    , 500

  $scope.release = (log) ->
    released = new Date()

  $scope.delete = (log) ->
    deleteConfirm = $ionicPopup.confirm(
      title: 'Log Eintrag löschen',
      template: 'Möchten Sie diesen Eintrag löschen?'
      cancelText: 'Abbrechen'
    )
    deleteConfirm.then (res) ->
      log.destroy().then query if res

  $scope.show = (log) ->
    #$ionicPopup.alert(title: "show #{log.id}")

  query()
