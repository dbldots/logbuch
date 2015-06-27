angular.module("logbuch").factory "Model", ($q, $log, DBService) ->
  class Model
    @columns: []
    @table: null

    @all: (order = 'id') ->
      deferred = $q.defer()

      query   = "SELECT * FROM #{@table} ORDER BY ?"
      values  = [order]
      records = []

      success = (result) ->
        i = 0
        while i < result.rows.length
          row = result.rows.item(i)
          records.push @fromDb(row)
          i += 1

        deferred.resolve(records)

      DBService.query(query: query, values: values).then success.bind(@)

      deferred.promise

    @fromDb: (object) ->
      record = new @
      angular.forEach @columns, (column) ->
        value = object[column.name]

        switch column.map
          when 'bool'
            value = if value == 1 then true else false
          when 'json'
            value = JSON.parse(value)

        record[column.name] = value

      record

    #@find: (id) ->
      #query   = "SELECT * FROM #{@table} WHERE id = ?"
      #values  = [id]

    #@where: (query, values) ->

    #@count: ->
      #query   = "SELECT COUNT(*) AS count FROM #{@table}"
      #values  = []

    @insert: (object) ->
      fields = []
      marks   = []
      values  = []
      angular.forEach @columns, (column) ->
        return if column.name == 'id'
        fields.push(column.name)
        marks.push('?')

        value = object[column.name]

        switch column.type
          when 'text'
            value ||= ''
          when 'integer', 'real'
            value ||= 0

        switch column.map
          when 'bool'
            value = if value == true then 1 else 0
          when 'json'
            value = JSON.stringify(value)

        values.push(value)

      query   = "INSERT INTO #{@table} (#{fields.join(',')}) VALUES (#{marks.join(',')})"
      values  = values

      DBService.query(query: query, values: values)

    @createTable: ->
      columns = []
      angular.forEach @columns, (column) ->
        columns.push "#{column.name} #{column.type}"

      query = "CREATE TABLE IF NOT EXISTS #{@table} (#{columns.join(",")})"
      DBService.query(query: query).then =>
        $log.info "Table #{@table} initialized"

    @dropTable: ->
      query = "DROP TABLE IF EXISTS #{@table}"
      DBService.query(query: query).then =>
        $log.info "Table #{@table} dropped"

    @resetTable: ->
      @dropTable()
      @createTable()

    save: ->
      @constructor.insert(@)

    destroy: ->
      query  = "DELETE FROM #{@constructor.table} WHERE id = ?"
      values = [@id]
      DBService.query(query: query, values: values)