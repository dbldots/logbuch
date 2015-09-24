angular.module("logbuch").controller "SettingsCtrl", ($scope, $state, StorageService) ->
  $scope.settings =
    name: StorageService.get('settings.name', 'No Name')

  $scope.save = ->
    angular.forEach $scope.settings, (value, key) ->
      StorageService.set("settings.#{key}", value)

    $state.go('more')

  $scope.cancel = ->
    $state.go('more')
