angular.module("logbuch").factory "QueryBuilder", (DB_CONFIG) ->
  all: (table, order = 'id') ->
    query: "SELECT * FROM #{table} ORDER BY ?"
    values: [order]

  find: (table, id) ->
    query: "SELECT * FROM #{table} WHERE id = ?"
    values: [id]

  count: (table) ->
    query: "SELECT COUNT(*) AS count FROM #{table}"
    values: []

  insert: (table, object) ->
    config  = DB_CONFIG.tables[table]['columns']
    columns = []
    marks   = []
    values  = []
    _.each config, (column) ->
      return if column.name == 'id'
      columns.push(column.name)
      marks.push('?')

      value = object[column.name]
      switch column.map
        when 'bool'
          value = if value == true then 1 else 0

      values.push(value)

    query: "INSERT INTO #{table} (#{columns.join(',')}) VALUES (#{marks.join(',')})"
    values: values

  delete: (table, id) ->
    query: "DELETE FROM #{table} WHERE id = ?"
    values: [id]
