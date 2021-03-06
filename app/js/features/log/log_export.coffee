angular.module("logbuch").factory "LogExport", ($cordovaFileOpener2, $filter, ToastrService, Log, DebugLog, StorageService) ->
  binaryArray = null
  filePath = null

  fail = (error) ->
    ToastrService.show('Log Export fehlgeschlagen!')
    new DebugLog('LogExport Export Error', error).save()

  gotFS = (fileSystem) ->
    filename = 'logExport.pdf'
    fileSystem.root.getFile(
      filename,
      { create: true, exclusive: false },
      gotFileEntry,
      fail
    )

  gotFileEntry = (fileEntry) ->
    filePath = fileEntry.toURL()
    fileEntry.createWriter(gotFileWriter, fail)

  gotFileWriter = (writer) ->
    writer.onwriteend = (evt) ->
      ToastrService.hide()
      $cordovaFileOpener2.open(
        filePath,
        'application/pdf'
      )

    writer.write(binaryArray)

  docDefinition = (logs) ->
    definition =
      pageOrientation: 'landscape'
      content: [
          text: "Logbuch von #{StorageService.get('settings.name', 'No Name')}"
          fontSize: 16
          bold: true
        ,
          text: "Erstellt am #{$filter('datetime')(moment().toISOString())}"
        ,
          text: ' '
          fontSize: 18
        ,
          table:
            headerRows: 1,
            widths: [ 100, '*', 150, 50, 50, 200 ],

            body: [
              [ 'Datum', 'Ereignis', 'Koordinaten', 'Distanz (km/nm)', 'Punkte', 'Notiz' ],
            ]
      ]

    total = 0
    angular.forEach logs, (log) ->
      total += log.points
      distance = if log.type == 'sea' then log.distance_nm else log.distance_km
      distance = $filter('float2')(distance)

      coords = if log.type == 'sea' || log.type == 'inland'
        [
          "#{$filter('dms_lat0')(log.start.lat)}, #{$filter('dms_lat0')(log.start.long)}",
          "#{$filter('dms_lat0')(log.destination.lat)}, #{$filter('dms_lat0')(log.destination.long)}"
        ]
      else
        "#{$filter('dms_lat0')(log.start.lat)}, #{$filter('dms_lat0')(log.start.long)}"

      definition.content[3].table.body.push([
        $filter('datetime')(log.start.timestamp),
        $filter('logFeatures')(log),
        coords,
        distance,
        String(log.points),
        String(log.comment)
      ])

    definition.content.push(
      text: ' '
      fontSize: 18
    )
    definition.content.push(
      text: "Total: #{total} Punkte"
      bold: true
    )

    definition

  run = ->
    ToastrService.show('Exportiere Logs...', true)
    Log.all().then (logs) ->
      try
        doc = docDefinition(logs)
        #doc = { content: 'This is an sample PDF printed with pdfMake' }

        if !window.cordova
          pdfMake.createPdf(doc).open()
          ToastrService.hide()

        else
          pdfMake.createPdf(doc).getBuffer (buffer) ->
            utf8 = new Uint8Array(buffer) # convert to UTF-8
            binaryArray = utf8.buffer    # convert to binary
            window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, gotFS, fail)

      catch error
        fail(error)

  run: run
