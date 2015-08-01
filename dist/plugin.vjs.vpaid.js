
/*
  Initialize the plugin
  @param options (optional) {object} configuration for the plugin
 */
(function(window, videojs) {

  /*
   * Runs the callback at the next available opportunity.
   * @see https://developer.mozilla.org/en-US/docs/Web/API/window.setImmediate
   */
  var defaults, setImmediate, vjsVPAID;
  setImmediate = function(callback) {
    return (window.setImmediate || window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.setTimeout)(callback, 0);
  };

  /*
  vjs.vpaidFlash
  
  * Contains functions to generate flash SWF object
  * Contains events used by SWF for ready, error, and general event throws
   */
  vjs.vpaidFlash = {};
  vjs.vpaidFlash.embedObject = function(swf, placeHolder, flashVars, params, attributes) {
    var code, obj, _;
    _ = this;
    code = _.generateEmbedCode(swf, flashVars, params, attributes);
    obj = vjs.createEl('div', {
      innerHTML: code
    }).childNodes[0];
    placeHolder.appendChild(obj);
    return placeHolder;
  };
  vjs.vpaidFlash.generateEmbedCode = function(swf, flashVars, params, attributes) {
    var attrsString, flashVarsString, objTag, paramsString, _;
    _ = this;
    objTag = '<object type="application/x-shockwave-flash" ';
    flashVarsString = '';
    paramsString = '';
    attrsString = '';
    if (flashVars) {
      vjs.obj.each(flashVars, function(key, val) {
        return flashVarsString += "" + key + "=" + val + "&amp;";
      });
    }
    params = vjs.obj.merge({
      movie: swf,
      flashVars: flashVarsString,
      allowScriptAccess: 'always',
      allowNetworking: 'all'
    }, params);
    vjs.obj.each(params, function(key, val) {
      return paramsString += "<param name='" + key + "' value='" + val + "' /> ";
    });
    attributes = vjs.obj.merge({
      'data': swf,
      'width': '100%',
      'height': '100%'
    }, attributes);
    vjs.obj.each(attributes, function(key, val) {
      return attrsString += "" + key + "='" + val + "' ";
    });
    return objTag + attrsString + '>' + paramsString + '</object>';
  };
  vjs.vpaidFlash.cancelContentPlay = function(player) {
    if (vjs.vpaidFlash.cancelPlayTimeout) {
      return;
    }
    return vjs.vpaidFlash.cancelPlayTimeout = setImmediate(function() {
      vjs.vpaidFlash.cancelPlayTimeout = null;
      if (!player.paused()) {
        return player.pause();
      }
    });
  };
  vjs.vpaidFlash['onReady'] = function(swfID) {};
  vjs.vpaidFlash['onEvent'] = function(swfID, eventName) {
    var _player;
    _player = vjs.players.player;
    return _player.trigger("vpaid_" + eventName);
  };
  vjs.vpaidFlash['onError'] = function(swfID, err) {
    var _player;
    _player = vjs.players.player;
    return _player.trigger("vpaid_error");
  };

  /*
  vjsVPAID Plugin
   */
  defaults = {
    vpaidSWF: "http://localhost:8000/dist/videojs-vpaid.swf",
    flashVars: {},
    attributes: {},
    url: "",
    debug: false,
    timeout: 5000
  };
  vjsVPAID = function(options) {
    var attributes, flashVars, objId, params, placeHolder, player, pluginId, settings, setupEvents, testPlaceholder;
    setupEvents = function() {
      var adCompleteFn, adErrorFn, adStartedFn, className, playFn;
      className = {
        vpaidActive: 'vjs-vpaid-active',
        vpaidStarted: 'vjs-vpaid-started'
      };
      playFn = function() {
        if (vjs.vpaidFlash['didComplete'] === false) {
          vjs.vpaidFlash['didComplete'] = true;
          vjs.vpaidFlash.cancelContentPlay(player);
          return player.el().className += " " + className.vpaidActive;
        }
      };
      adCompleteFn = function() {
        player.removeClass(className.vpaidActive);
        player.removeClass(className.vpaidStarted);
        player.el().removeChild(document.getElementById(pluginId));
        player.off('vpaid_AdStarted', adStartedFn);
        player.off('vpaid_AdComplete', adCompleteFn);
        player.off('vpaid_error', adErrorFn);
        return player.off('play', playFn);
      };
      adStartedFn = function() {
        return player.el().className += " " + className.vpaidStarted;
      };
      adErrorFn = function() {
        return player.trigger("vpaid_AdComplete");
      };
      player.on('vpaid_AdStarted', adStartedFn);
      player.on('vpaid_AdComplete', adCompleteFn);
      player.on('vpaid_error', adErrorFn);
      return player.on('play', playFn);
    };
    settings = videojs.util.mergeOptions(defaults, options);
    player = this;
    pluginId = player.id() + '_vpaidflash';
    vjs.vpaidFlash['_player'] = player;
    vjs.vpaidFlash['didComplete'] = false;
    objId = player.id() + '_vpaidflash_api';
    placeHolder = vjs.createEl('div', {
      id: pluginId,
      className: 'vjs-vpaid'
    });
    options['vpaidUrl'] = options['vpaidUrl'].replace(/\&/ig, "%26").replace(/\+/ig, "%2B").replace(/\=/ig, "%3D").replace(/\ /ig, "%20");
    flashVars = vjs.obj.merge({
      'readyFunction': 'vjs.vpaidFlash.onReady',
      'eventProxyFunction': 'vjs.vpaidFlash.onEvent',
      'errorEventProxyFunction': 'vjs.vpaidFlash.onError',
      'muted': settings.muted,
      'vpaidUrl': options['vpaidUrl'] || defaults.url,
      'vpaidDebug': options['debug'] || defaults.debug,
      'vpaidTimeout': options['timeout'] || defaults.timeout
    }, settings['flashVars']);
    params = vjs.obj.merge({
      'wmode': 'opaque',
      'bgcolor': '#000000'
    }, settings['params']);
    attributes = vjs.obj.merge({
      'id': objId,
      'name': objId,
      'class': 'vjs-vpaid'
    }, settings['attributes']);
    testPlaceholder = vjs.vpaidFlash.embedObject(settings['vpaidSWF'], placeHolder, flashVars, params, attributes);
    player.el().appendChild(testPlaceholder);
    return setupEvents();
  };
  return videojs.plugin('vjsVPAID', vjsVPAID);
})(window, window.videojs);
