# Initialize angular's app.

# "angulartics.google.analytics"
# "angulartics.google.analytics.cordova",
app = angular.module(GLOBALS.ANGULAR_APP_NAME, [
  "#{GLOBALS.ANGULAR_APP_NAME}.templates"
  "ionic"
  "ngCordova"
  "ion-datetime-picker"
])
