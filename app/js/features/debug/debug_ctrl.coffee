angular.module("logbuch").controller "DebugCtrl", ($scope, $state, DebugLog) ->
  DebugLog.all().then (debug_logs) ->
    $scope.debug_logs = debug_logs
