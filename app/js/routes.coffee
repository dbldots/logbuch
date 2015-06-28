angular.module("logbuch")

.config ($stateProvider, $urlRouterProvider) ->

  # Ionic uses AngularUI Router which uses the concept of states
  # Learn more here: https://github.com/angular-ui/ui-router
  # Set up the various states which the app can be in.

  # the pet tab has its own child nav-view and history
  $stateProvider

  .state "tab",
    url: "/tab"
    abstract: true
    templateUrl: "templates/tabs.html"

  .state "tab.track",
    url: "/track"
    views:
      "track-tab":
        templateUrl: "templates/track.html"
        controller: "TrackCtrl"

  .state "tab.log",
    url: "/log"
    views:
      "log-tab":
        templateUrl: "templates/log.html"
        controller: "LogCtrl"

  .state "tab.log-details",
    url: "/log/:log_id"
    views:
      "log-tab":
        templateUrl: "templates/log_details.html"
        controller: "LogDetailsCtrl"

  .state "tab.add",
    url: "/add"
    views:
      "add-tab":
        templateUrl: "templates/add.html"

  .state "tab.add-track",
    url: "/add/track"
    views:
      "add-tab":
        templateUrl: "templates/add/track.html"
        controller: "AddCtrl"

  .state "tab.add-mast",
    url: "/add/mast"
    views:
      "add-tab":
        templateUrl: "templates/add/mast.html"
        controller: "AddCtrl"

  .state "tab.add-lock",
    url: "/add/lock"
    views:
      "add-tab":
        templateUrl: "templates/add/lock.html"
        controller: "AddCtrl"

  .state "tab.add-trailer",
    url: "/add/trailer"
    views:
      "add-tab":
        templateUrl: "templates/add/trailer.html"
        controller: "AddCtrl"

  .state "tab.add-distance",
    url: "/add/distance"
    views:
      "add-tab":
        templateUrl: "templates/add/distance.html"
        controller: "AddCtrl"

  .state "tab.add-distance-plus",
    url: "/add/distance_plus"
    views:
      "add-tab":
        templateUrl: "templates/add/distance_plus.html"
        controller: "AddCtrl"

  .state "tab.add-club-trip",
    url: "/add/club_trip"
    views:
      "add-tab":
        templateUrl: "templates/add/club_trip.html"
        controller: "AddCtrl"

  .state "tab.add-regatta",
    url: "/add/regatta"
    views:
      "add-tab":
        templateUrl: "templates/add/regatta.html"
        controller: "AddCtrl"

  .state "more",
    url: "/more"
    templateUrl: "templates/more.html"
    controller: "MoreCtrl"

  .state "debug",
    url: "/debug"
    templateUrl: "templates/debug.html"
    controller: "DebugCtrl"

  .state "settings",
    url: "/settings"
    templateUrl: "templates/settings.html"
    controller: "SettingsCtrl"

  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/tab/track"
