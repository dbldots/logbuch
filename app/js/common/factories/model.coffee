angular.module("logbuch").factory "Model", ($q, $log, DBService) ->
  class Model
    @columns: []
    @table: null

    @all: (order = 'id') ->
      deferred = $q.defer()

      query   = "SELECT * FROM #{@table} ORDER BY #{order}"
      records = []

      success = (result) ->
        i = 0
        while i < result.rows.length
          row = result.rows.item(i)
          records.push @fromDb(row)
          i += 1

        deferred.resolve(records)

      DBService.query(query: query).then success.bind(@)

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

    @find: (id) ->
      deferred = $q.defer()
      query   = "SELECT * FROM #{@table} WHERE id = #{id}"

      success = (result) ->
        row = result.rows.item(0)
        log = @fromDb(row)

        deferred.resolve(log)

      DBService.query(query: query).then success.bind(@)

      deferred.promise

    @insert: (object) ->
      fields = []
      marks   = []
      values  = []
      angular.forEach @columns, (column) =>
        return if column.name == 'id'
        values.push @map(column, object[column.name])
        fields.push(column.name)
        marks.push('?')

      query   = "INSERT INTO #{@table} (#{fields.join(',')}) VALUES (#{marks.join(',')})"
      values  = values

      DBService.query(query: query, values: values)

    @update: (object) ->
      updates = []
      values  = []
      angular.forEach @columns, (column) =>
        return if column.name == 'id'

        values.push @map(column, object[column.name])
        updates.push "#{column.name} = ?"

      query   = "UPDATE #{@table} SET #{updates.join(', ')} WHERE id = #{object.id}"
      values  = values

      DBService.query(query: query, values: values)

    @map: (column, value) ->
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

      value

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

    update: ->
      @constructor.update(@)

    destroy: ->
      query  = "DELETE FROM #{@constructor.table} WHERE id = ?"
      values = [@id]
      DBService.query(query: query, values: values)
