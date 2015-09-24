app = angular.module(GLOBALS.ANGULAR_APP_NAME)


# Run the app only after cordova has been initialized
# (this is why we don't include ng-app in the index.jade)
ionic.Platform.ready ->
  console.log 'ionic.Platform is ready! Running `angular.bootstrap()`...' unless GLOBALS.ENV == "test"
  angular.bootstrap document, [GLOBALS.ANGULAR_APP_NAME]
  L.Icon.Default.imagePath = 'components/leaflet/dist/images'


app.run ($log, $timeout, $rootScope, Log, DebugLog) ->
  $log.debug "Ionic app \"#{GLOBALS.ANGULAR_APP_NAME}\" has just started (app.run)!" unless GLOBALS.ENV == "test"

  # Finally, let's show the app, by hiding the splashscreen
  # (it should be visible up until this moment)
  $timeout ->
    navigator.splashscreen?.hide()

  Log.createTable()
  DebugLog.createTable()

app.run ($rootScope, $state, DebugLog)->
  if window.plugins?.webintent
    readGpx = (url) ->
      return if _.isEmpty(url)

      $rootScope.importedGpx ||= []

      success = (entry) ->
        entry.file (file) ->
          reader = new FileReader()
          reader.onloadend = (evt) ->
            gpx = evt.target.result
            $rootScope.importedGpx.push gpx
            $state.go('tab.add-gpx-track')

          reader.readAsText(file)

      error = ->
        new DebugLog("Reading of #{url} failed.")

      window.resolveLocalFileSystemURL url, success, error

    window.plugins.webintent.getUri (url) ->
      readGpx(url)

    window.plugins.webintent.getExtra window.plugins.webintent.EXTRA_STREAM, (url) ->
      readGpx(url)

# DEBUG
app.run ($timeout, $window) ->
  # Useful for debugging, like `$NG("$rootScope")`
  $timeout ->
    $window.$NG = angular.element(document.body).injector()?.get
