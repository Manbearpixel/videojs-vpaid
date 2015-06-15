###
  Initialize the plugin
  @param options (optional) {object} configuration for the plugin
###
((window, videojs)->

  ###
   * Runs the callback at the next available opportunity.
   * @see https://developer.mozilla.org/en-US/docs/Web/API/window.setImmediate
  ###
  setImmediate = (callback)->
    return (
      window.setImmediate ||
      window.requestAnimationFrame ||
      window.mozRequestAnimationFrame ||
      window.webkitRequestAnimationFrame ||
      window.setTimeout
    )(callback, 0);


  ###
  vjs.vpaidFlash

  * Contains functions to generate flash SWF object
  * Contains events used by SWF for ready, error, and general event throws
  ###
  vjs.vpaidFlash = {}

  # Create embedable flash object
  vjs.vpaidFlash.embedObject = (swf, placeHolder, flashVars, params, attributes)->
    _ = this

    code = _.generateEmbedCode(swf, flashVars, params, attributes)

    # get element by embedding code and retrieving created element
    obj = vjs.createEl('div', {
      innerHTML: code
    }).childNodes[0]

    placeHolder.appendChild(obj)
    placeHolder

  # Generate object embed code (contributed from: videojs-vpaid-flash)
  vjs.vpaidFlash.generateEmbedCode = (swf, flashVars, params, attributes)->
    _ = this

    objTag          = '<object type="application/x-shockwave-flash" '
    flashVarsString = ''
    paramsString    = ''
    attrsString     = ''

    # convert flash vars to string format
    if flashVars
      vjs.obj.each(flashVars, (key, val)->
        flashVarsString += "#{key}=#{val}&amp;"
      )

    # add swf, flashvars, and other default params
    params = vjs.obj.merge({
      movie             : swf
      flashVars         : flashVarsString
      allowScriptAccess : 'always' # required for swf communication
      allowNetworking   : 'all'
    }, params)

    # create param tags string
    vjs.obj.each(params, (key, val)->
      paramsString += "<param name='#{key}' value='#{val}' /> "
    )

    attributes = vjs.obj.merge({
      'data'    : swf # add swf to attributes (need both for IE and other browsers)
      'width'   : '100%'
      'height'  : '100%'
    }, attributes)

    # create attributes string
    vjs.obj.each(attributes, (key, val)->
      attrsString += "#{key}='#{val}' "
    )
    objTag + attrsString + '>' + paramsString + '</object>'

  # Cancel content playback
  vjs.vpaidFlash.cancelContentPlay = (player)->
    if vjs.vpaidFlash.cancelPlayTimeout
      return

    # deregister cancel timeout so subsequent pauses are cancelled
    vjs.vpaidFlash.cancelPlayTimeout = setImmediate(()->
      vjs.vpaidFlash.cancelPlayTimeout = null
      if not player.paused()
        player.pause()
    )

  vjs.vpaidFlash['onReady'] = (swfID)->

  vjs.vpaidFlash['onEvent'] = (swfID, eventName) ->
    console.log("[VPAID] OnEvent\nSWF:\t\t#{swfID}\nEvent:\t\t#{eventName}\nTrigger:\tvpaid_#{eventName}\n-----\t-----")
    _player = vjs.players.player
    _player.trigger("vpaid_#{eventName}")

  vjs.vpaidFlash['onError'] = (swfID, err)->
    console.log("[VPAID] OnError\nSWF:\t\t#{swfID}\nEvent:\t\tvpaid_error", err)
    _player = vjs.players.player
    _player.trigger("vpaid_error")


  ###
  vjsVPAID Plugin
  ###

  # default options
  defaults = {
    vpaidSWF    : "http://localhost:8888/dist/video-js.swf"
    muted       : false
    flashVars   : {}
    params      : {}
    attributes  : {}
  }

  vjsVPAID = (options)->
    settings  = videojs.util.mergeOptions(defaults, options)
    player    = this
    pluginId  = player.id() + '_vpaidflash'

    # add information to vjs.vpaidFlash
    vjs.vpaidFlash['_player']     = player
    vjs.vpaidFlash['didComplete'] = false

    # Generate ID for swf object
    objId = player.id()+'_vpaidflash_api'

    # Create the flash placeholder
    placeHolder = vjs.createEl('div', {
      id        : pluginId
      className : 'vjs-vpaid'
    })

    # Merge flash variables to pass to SWF
    flashVars = vjs.obj.merge({

        #   SWF Callback Functions
        'readyFunction'				    : 'vjs.vpaidFlash.onReady'
        'eventProxyFunction'			: 'vjs.vpaidFlash.onEvent'
        'errorEventProxyFunction'	: 'vjs.vpaidFlash.onError'

        #   Player Settings
        'muted'		  : settings.muted

        #   VPAID Settings
        'vpaidUrl'    : options['vpaidUrl']
        'vpaidParams' : options['vpaidParams'].replace(/&/ig, "||")
        'vpaidDebug'  : options['debug']

    }, settings['flashVars'])

    # Merge params to pass to Object Element
    params = vjs.obj.merge({
        'wmode'     : 'opaque', # Opaque is needed to overlay controls, but can affect playback performance
        'bgcolor'   : '#000000' # Using bgcolor prevents a white flash when the object is loading
    }, settings['params'])

    # Merge attributes to Object Element
    attributes = vjs.obj.merge({
        'id'    : objId,
        'name'  : objId, # Both ID and Name needed for swf to identify itself
        'class' : 'vjs-vpaid'
    }, settings['attributes'])

    # Generate the embed swf object
    testPlaceholder  = vjs.vpaidFlash.embedObject(settings['vpaidSWF'], placeHolder, flashVars, params, attributes)

    # Add embed object to player
    player.el().appendChild(testPlaceholder)


    # on play
    player.on('play', (event)->
      if vjs.vpaidFlash['didComplete'] is false
        vjs.vpaidFlash['didComplete'] = true
        vjs.vpaidFlash.cancelContentPlay(player)
        player.el().className += ' vjs-vpaid-active';
    )

    # on ad complete
    player.on('vpaid_AdComplete', (event)->
      player.removeClass('vjs-vpaid-active')
      player.removeClass('vjs-vpaid-started')
      player.el().removeChild(document.getElementById(pluginId))
    )

    # on ad started
    player.on('vpaid_AdStarted', (event)->
      player.el().className += ' vjs-vpaid-started';
    )

  videojs.plugin('vjsVPAID', vjsVPAID)
)(window, window.videojs)

