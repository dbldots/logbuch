angular.module("logbuch").controller "DebugCtrl", ($scope, $state, $ionicPopup, $timeout, DebugLog, StorageService) ->
  loadLog = ->
    DebugLog.all().then (debug_logs) ->
      $scope.debug_logs = debug_logs
      $timeout loadLog, 10000 if $scope.settings.debug

  $scope.settings =
    debug: if StorageService.get('settings.debug', 'false') == 'true' then true else false

  $scope.$watch 'settings.debug', (value) ->
    StorageService.set("settings.debug", value)
    loadLog()

  $scope.reset = ->
    $ionicPopup.confirm(
      title: 'Debug Log zurücksetzen'
      template: 'Sind Sie sicher (Log wird gelöscht)?'
      cancelText: 'Abbrechen'
    ).then (result) ->
      if (result)
        DebugLog.resetTable()
        $scope.debug_logs = []

  loadLog()
