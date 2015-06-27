# mocha.setup
#   bail: false
#   ignoreLeaks: true

window.GLOBALS =
  ANGULAR_APP_NAME: "logbuch"
  ENV: 'test'

beforeEach module(GLOBALS.ANGULAR_APP_NAME)

afterEach ->
  inject ($httpBackend) ->
    $httpBackend.verifyNoOutstandingRequest()
    $httpBackend.verifyNoOutstandingExpectation()

  sessionStorage.clear()
  localStorage.clear()

