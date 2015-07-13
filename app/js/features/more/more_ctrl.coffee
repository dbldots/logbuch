angular.module("logbuch").controller "MoreCtrl", ($scope, $state, $ionicPopup, Log, DebugLog, StorageService) ->
  $scope.resetDB = ->
    $ionicPopup.confirm(
      title: 'Datenbank zurücksetzen'
      template: 'Sind Sie sicher (alle Daten werden gelöscht)?'
      cancelText: 'Abbrechen'
    ).then (result) ->
      if (result)
        Log.resetTable()
        DebugLog.resetTable()

    StorageService.clearAll()

  $scope.resetDebugLog = ->
    $ionicPopup.confirm(
      title: 'Debug Log zurücksetzen'
      template: 'Sind Sie sicher (Log wird gelöscht)?'
      cancelText: 'Abbrechen'
    ).then (result) ->
      if (result)
        DebugLog.resetTable()
