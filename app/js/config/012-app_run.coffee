app = angular.module(GLOBALS.ANGULAR_APP_NAME)


# Run the app only after cordova has been initialized
# (this is why we don't include ng-app in the index.jade)
ionic.Platform.ready ->
  console.log 'ionic.Platform is ready! Running `angular.bootstrap()`...' unless GLOBALS.ENV == "test"
  angular.bootstrap document, [GLOBALS.ANGULAR_APP_NAME]


app.run ($log, $timeout, $rootScope, Log, DebugLog) ->
  $log.debug "Ionic app \"#{GLOBALS.ANGULAR_APP_NAME}\" has just started (app.run)!" unless GLOBALS.ENV == "test"

  # Finally, let's show the app, by hiding the splashscreen
  # (it should be visible up until this moment)
  $timeout ->
    navigator.splashscreen?.hide()

  $rootScope.map = plugin.google.maps.Map.getMap()

  Log.createTable()
  DebugLog.createTable()
