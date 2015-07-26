angular.module("logbuch").factory "DebugLog", ($log, Model, StorageService) ->
  class DebugLog extends Model
    @table = 'debug_logs'
    @columns = [
      { name: "id",        type: "integer primary key"  }
      { name: "msg",       type: "text"                 }
      { name: "timestamp", type: "text"                 }
    ]

    constructor: ->
      @msg = JSON.stringify(arguments)
      @timestamp = moment().toISOString()

    save: ->
      if StorageService.get('settings.debug', 'false') == 'true'
        #$log.info @msg, @timestamp
        @constructor.insert(@)
