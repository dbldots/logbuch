angular.module("logbuch").factory "LogExport", ($cordovaFileOpener2, $filter, ToastrService, Log, DebugLog) ->
  class LogExport
    binaryArray: null
    filePath: null

    fail: (error) ->
      ToastrService.show('Log Export fehlgeschlagen!')
      new DebugLog(JSON.stringify(error)).save()
      console.log error

    gotFS: (fileSystem) ->
      console.log 'got file system', fileSystem
      filename = 'logExport.pdf'
      fileSystem.root.getFile(
        filename,
        { create: true, exclusive: false },
        @gotFileEntry,
        @fail
      )

    gotFileEntry: (fileEntry) ->
      console.log 'got file entry', fileEntry
      @filePath = fileEntry.toURL()
      console.log 'file path', @filePath
      fileEntry.createWriter(@gotFileWriter, fail)

    gotFileWriter: (writer) ->
      console.log 'got file writer', writer
      writer.onwriteend = (evt) =>
        $cordovaFileOpener2.open(
          @filePath,
          'application/pdf'
        )

      writer.write(@binaryArray)

    docDefinition: (logs) ->
      docDefinition =
        pageOrientation: 'landscape'
        content: [
          table:
            headerRows: 1,
            widths: [ 100, '*', 150, 50, 50, 200 ],

            body: [
              [ 'Datum', 'Ereignis', 'Koordinaten', 'Distanz (km/nm)', 'Punkte', 'Notiz' ],
            ]
        ]

      angular.forEach logs, (log) ->
        distance = if log.type == 'sea' then log.distance_nm else log.distance_km
        distance = $filter('float2')(distance)

        coords = if log.type == 'sea' || log.type == 'inland'
          [
            "#{$filter('dms_lat0')(log.start.lat)}, #{$filter('dms_lat0')(log.start.long)}",
            "#{$filter('dms_lat0')(log.destination.lat)}, #{$filter('dms_lat0')(log.destination.long)}"
          ]
        else
          "#{$filter('dms_lat0')(log.start.lat)}, #{$filter('dms_lat0')(log.start.long)}"

        docDefinition.content[0].table.body.push([
          $filter('datetime')(log.start.timestamp),
          $filter('logFeatures')(log),
          coords,
          distance,
          String(log.points),
          String(log.comment)
        ])

      console.log docDefinition
      docDefinition

    run: ->
      Log.all().then (logs) =>
        try
          #docDefinition = @docDefinition(logs)
          docDefinition = { content: 'This is an sample PDF printed with pdfMake' }

          if !window.cordova
            pdfMake.createPdf(docDefinition).open()

          else
            pdfMake.createPdf(docDefinition).getBuffer (buffer) =>
              console.log 'got buffer', buffer
              utf8 = new Uint8Array(buffer) # convert to UTF-8
              @binaryArray = utf8.buffer    # convert to binary
              window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, @gotFS, @fail)

        catch error
          @fail(error)
