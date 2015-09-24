angular.module("logbuch").controller "LogCtrl", ($scope, $state, $stateParams, $ionicHistory, $ionicPopup, $timeout, $ionicScrollDelegate, Log, LogExport, ToastrService) ->
  query = ->
    Log.all('id DESC').then (logs) ->
      $scope.logs = logs
      $scope.total = 0
      angular.forEach logs, (log) -> $scope.total += log.points

  # touch + released is a workaround since on-hold does not work with android
  released = undefined
  touchPos = undefined
  $scope.touch = (log) ->
    released = false
    touchPos = $ionicScrollDelegate.getScrollPosition().top

    $timeout ->
      pos = $ionicScrollDelegate.getScrollPosition().top
      if !released && Math.abs(pos - touchPos) < 10
        $scope.delete(log)
    , 600

  $scope.release = (log) ->
    released = true

  $scope.delete = (log) ->
    deleteConfirm = $ionicPopup.confirm(
      title: 'Log Eintrag löschen',
      template: 'Möchten Sie diesen Eintrag löschen?'
      cancelText: 'Abbrechen'
    )
    deleteConfirm.then (res) ->
      log.destroy().then query if res

  $scope.show = (log) ->
    $state.go('tab.log-details', log_id: log.id)

  $scope.export = ->
    LogExport.run()

  query()
