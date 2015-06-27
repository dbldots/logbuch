angular.module("logbuch")

.factory "DBService", ($window, $q, $log) ->
  db: if window.cordova
    # mobile
    window.sqlitePlugin.openDatabase("DB", "1.0", "database", -1)
  else
    # browser
    window.openDatabase("DB", "1.0", "database", -1)

  query: (command) ->
    deferred  = $q.defer()
    @db.transaction (transaction) ->
      transaction.executeSql command.query, command.values || [], ((transaction, result) ->
        deferred.resolve result
      ), (transaction, error) ->
        $log.error 'DBService', error
        deferred.reject error

    deferred.promise
