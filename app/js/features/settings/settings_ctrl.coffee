angular.module("logbuch").controller "SettingsCtrl", ($scope, $state, StorageService) ->
  $scope.settings =
    name: StorageService.get('settings.name', 'No Name')
    debug: if StorageService.get('settings.debug', 'false') == 'true' then true else false

  $scope.save = ->
    angular.forEach $scope.settings, (value, key) ->
      StorageService.set("settings.#{key}", value)

    $state.go('more')

  $scope.cancel = ->
    $state.go('more')
