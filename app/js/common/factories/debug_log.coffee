angular.module("logbuch").factory "DebugLog", (Model) ->
  class DebugLog extends Model
    @table = 'debug_logs'
    @columns = [
      { name: "id",        type: "integer primary key"  }
      { name: "msg",       type: "text"                 }
      { name: "timestamp", type: "text"                 }
    ]

    constructor: (msg) ->
      @msg = msg
      @timestamp = moment().toISOString()
