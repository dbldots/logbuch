angular.module("logbuch").controller "MoreCtrl", ($scope, $state, Log, DebugLog, StorageService) ->
  $scope.resetDB = ->
    Log.resetTable()
    DebugLog.resetTable()
    StorageService.setObject('currentTrack', {})
