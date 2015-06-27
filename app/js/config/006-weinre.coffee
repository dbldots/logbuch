# To debug, go to http://localhost:31173/client/#anonymous
#try
  #if GLOBALS.WEINRE_ADDRESS && (ionic.Platform.isAndroid() || ionic.Platform.isIOS()) && !navigator.platform.match(/MacIntel/i)
    #window.addElement document, "script", id: "weinre-js", src: "http://#{GLOBALS.WEINRE_ADDRESS}/target/target-script-min.js#anonymous"
#catch error
  #console.log error
