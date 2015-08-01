package com.videojs.vpaid {
    
    import com.videojs.*;
    import com.videojs.structs.ExternalErrorEventName;
    import com.videojs.structs.ExternalEventName;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    /*import flash.net.URLRequest;*/
	import flash.net.*;
	import flash.external.ExternalInterface;
    import flash.system.LoaderContext;
    import com.videojs.vpaid.events.VPAIDEvent;
	
	import flash.utils.*;

    public class AdContainer extends Sprite {
        
        private var _model: VideoJSModel;
        private var _src: String;
        private var _vpaidAd: *;
        private var _isPlaying:Boolean = false;
        private var _isPaused:Boolean = true;
        private var _hasEnded:Boolean = false;
        private var _loadStarted:Boolean = false;
		
		private var _debug:Boolean = false;
		
		private var _adResponseTimeoutDelay:Number = 5000;
		private var _intervalId:uint;
		private var _adTimeout:Timer;

        public function AdContainer(){
            _model = VideoJSModel.getInstance();
        }
		
		public function console(mixedVar:*):void {
			if (_debug) {
				ExternalInterface.call("console.info", "[ActionScript - AdContainer] console ::");
				ExternalInterface.call("console.log", mixedVar);
				ExternalInterface.call("console.log", "\t-----\t-----");
			}
		}
		
        public function setDebug(pValue):void {
            _debug = pValue;
        }
		
        public function setTimeout(pValue):void {
            _adResponseTimeoutDelay = pValue;
        }

        public function get hasActiveAdAsset(): Boolean {
            return _vpaidAd != null;
        }

        public function get playing(): Boolean {
            return _isPlaying;
        }

        public function get paused(): Boolean {
            return _isPaused;
        }

        public function get ended(): Boolean {
            return _hasEnded;
        }

        public function get loadStarted(): Boolean {
            return _loadStarted;
        }

        public function get time(): Number {
            if (_model.duration > 0 &&
                hasActiveAdAsset &&
                _vpaidAd.hasOwnProperty("adRemainingTime") &&
                _vpaidAd.adRemainingTime >= 0 &&
                !isNaN(_vpaidAd.adRemainingTime)) {
                return _model.duration - _vpaidAd.adRemainingTime;
            } else {
                return 0;
            }
        }

        public function set src(pSrc:String): void {
            _src = pSrc;
			console("Set SRC!!!");
        }
        public function get src():String {
            return _src;
        }
		
		public function setSrcTest(pSrc:String):void {
			console("incoming src: " + pSrc);
			_src = pSrc;
			console("survey says... " + _src);
		}
		
		public function getSrc():String {
			return _src;
		}

        public function resize(width: Number, height: Number, viewMode: String = "normal"): void {
            if (hasActiveAdAsset) {
                _vpaidAd.resizeAd(width, height, viewMode);
            }
        }

        public function pausePlayingAd(): void {
            if (playing && !paused) {
                _isPlaying = true;
                _isPaused = true;
                _vpaidAd.pauseAd();
                _model.broadcastEventExternally(ExternalEventName.ON_PAUSE);
            }
        }

        public function resumePlayingAd(): void {
            if (playing && paused) {
                _isPlaying = true;
                _isPaused = false;
                _vpaidAd.resumeAd();
                _model.broadcastEventExternally(ExternalEventName.ON_RESUME);
            }
        }
        
        private function onAdLoaded(): void {
            addChild(_vpaidAd);
			console("ONADLOADED");
			_model.broadcastEventExternally(VPAIDEvent.AdLoaded);
            _vpaidAd.startAd();
        }

        private function onAdStarted(): void {
			console("ONADSTARTED");
			clearTimeout();
			
            _model.broadcastEventExternally(ExternalEventName.ON_START);
            _model.broadcastEventExternally(VPAIDEvent.AdStarted);
            _isPlaying = true;
            _isPaused = false;
        }
        
        private function onAdError(): void {
            _model.broadcastErrorEventExternally(VPAIDEvent.AdCreativeError);
            _vpaidAd.stopAd();
        }
        
        private function onAdStopped(): void {
            if (!_hasEnded) {
                _isPlaying = false;
                _hasEnded = true;
                _vpaidAd = null;
                _model.broadcastEventExternally(VPAIDEvent.AdComplete);
            }
        }
		
        private function onAdClickThru(): void {
			console("-- ON AdClickThru");
			_model.broadcastEventExternally(VPAIDEvent.AdClickThru);
        }
		
        private function onAdPaused(): void {
			console("-- ON AdPaused");
			_model.broadcastEventExternally(VPAIDEvent.AdPaused);
        }
		
        private function onAdPlaying(): void {
			console("-- ON ADPLAYING");
			_model.broadcastEventExternally(VPAIDEvent.AdPlaying);
        }
		
        private function onAdVideoFirstQuartile(): void {
			console("-- ON AdVideoFirstQuartile");
			_model.broadcastEventExternally(VPAIDEvent.AdVideoFirstQuartile);
        }
		
        private function onAdVideoMidpoint(): void {
			console("-- ON AdVideoMidpoint");
			_model.broadcastEventExternally(VPAIDEvent.AdVideoMidpoint);
        }
		
        private function onAdVideoThirdQuartile(): void {
			console("-- ON AdVideoThirdQuartile");
			_model.broadcastEventExternally(VPAIDEvent.AdVideoThirdQuartile);
        }
		
		
		public function abortAd(): void {
			console("ABORTING AD");
			_model.broadcastErrorEventExternally(VPAIDEvent.AdCreativeError);
            _vpaidAd.stopAd();
		}
	
		
		/*
			loadVPAIDXML
			
			param vpaidAdURL The URL to grab a VPAID Ad XML
			param onComplete The function to call when complete
			
		*/
		public function loadVPAIDXML(adUrl:String, onComplete:Function):* {
			
			console("requesting vpaid...");
			
			// Split URL to get url and params
			var urlSplit:Array 		= adUrl.split("?");
			var urlStr:String 		= urlSplit[0];
			var urlParams:String	= urlSplit[1];
				
			console("url::" + urlStr);
			console("params::" + urlParams);
		
			// initiate urlrequest
			var request:URLRequest = new URLRequest(adUrl);
			request.method = URLRequestMethod.GET;
		
			// initiate urlvariables
			var variables:URLVariables = new URLVariables();
			
			// loop through variables and add them to urlvariables
			var arrParams:Array = urlParams.split("&");
			for (var i = 0; i < arrParams.length; i++) {
				var param:Array = arrParams[i].split("=");
				variables[param[0]] = param[1];
				console("-- ADDING PARAM: " + param[0] + "=" + param[1]);
			}
			
			request.data = variables;
		
			// set up the search expression:
			/*var undPatrn:RegExp = /%5f/gi;*/

			/*ExternalInterface.call("console.log", "Without '_': " + variables.toString());*/
			/*ExternalInterface.call("console.log", "With '_': " + variables.toString().replace(undPatrn, "_"));*/

			// navigate with underscore:    
			/*request.data = variables.toString();*/
			/*request.data = variables.toString().replace(undPatrn, "_");*/
			
		
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		public function findVPAIDSWF(xmlSrc:String):String {
			
			// create new XML from xmlSrc
			/*var vpaidXML = new XML(event.target.data);*/
			var vpaidXML = new XML(xmlSrc);
		
			console("ad title test::" + vpaidXML.Ad.InLine.AdTitle.toString());
			console("ad vpaid version test::" + vpaidXML.attribute("version").toXMLString());
		
			// determine vpaid ad swf url within vpaidXML.Ad.InLine.Creatives
			var vpaidSWFURL:String = "";
			for each (var mediaFile:XML in vpaidXML.Ad.InLine.Creatives.Creative.Linear.MediaFiles.MediaFile) {
				console("MEDIA FILE");
				console(mediaFile.toString());
				if (mediaFile.toString().indexOf(".swf") != -1) {
					vpaidSWFURL = mediaFile;
				}
				
				/*var hasLinear:Boolean = (creative.Linear.children().length() > 0);
				if (hasLinear) {
					ExternalInterface.call("console.log", "CREATIVE!!!");
					ExternalInterface.call("console.log", creative.toXMLString());
					vpaidSWFURL = creative.Linear.MediaFiles[0].MediaFile.toString();
				}*/
			}
		
			if (vpaidSWFURL != "") {
				/*console("ad swf found::" + vpaidSWFURL);*/
				return vpaidSWFURL;
			}
			else {
				/*console("no ad swf found, aborting?");*/
				return "error";
			}
		}
        
        public function loadAdAsset(): void {
			console("load ad asset: " + _src);
            _loadStarted = true;
            var loader:Loader = new Loader();
            var loaderContext:LoaderContext = new LoaderContext();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Object): void {
                successfulCreativeLoad(evt);
            });
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 
                function(evt:SecurityErrorEvent): void {
                    throw new Error(evt.text);
                });
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, 
                function(evt:IOErrorEvent): void {
                    throw new Error(evt.text);
                });
            loader.load(new URLRequest(_src), loaderContext);
        }
        
        private function successfulCreativeLoad(evt: Object): void {

			console("successful creative load!");
            _vpaidAd = evt.target.content.getVPAID();
			/*console(_vpaidAd);*/
            var duration = _vpaidAd.hasOwnProperty("adDuration") ? _vpaidAd.adDuration : 0,
                width    = _vpaidAd.hasOwnProperty("adWidth") ? _vpaidAd.adWidth : 0,
                height   = _vpaidAd.hasOwnProperty("adHeight") ? _vpaidAd.adHeight : 0;

            if (!isNaN(duration) && duration > 0) {
                _model.duration = duration;
            }
            if (!isNaN(width) && width > 0) {
                _model.width = width;
            }
            if (!isNaN(height) && height > 0) {
                _model.height = height;
            }
			
			console("Duration: " + duration + " | Width: " + width + " | Height: " + height);

            _vpaidAd.addEventListener(VPAIDEvent.AdLoaded, function():void {
				console("OnAdLoaded");
                onAdLoaded();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdLog, function(data:*):void {
				console("OnAdLog");
				/*console(data);*/
            });
            
            _vpaidAd.addEventListener(VPAIDEvent.AdStopped, function():void {
				console("OnAdStoppped");
                onAdStopped();
            });
            
            _vpaidAd.addEventListener(VPAIDEvent.AdError, function():void {
				console("OnAdError");
                onAdError();
            });

            _vpaidAd.addEventListener(VPAIDEvent.AdStarted, function():void {
				console("OnAdStarted");
                onAdStarted();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdClickThru, function():void {
				console("OnAdClickThru");
                onAdClickThru();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdPaused, function():void {
				console("OnAdPaused");
                onAdPaused();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdPlaying, function():void {
				console("OnAdPlaying");
                onAdPlaying();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdVideoFirstQuartile, function():void {
				console("AdVideoFirstQuartile");
                onAdVideoFirstQuartile();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdVideoMidpoint, function():void {
				console("AdVideoMidpoint");
                onAdVideoMidpoint();
            });
			
            _vpaidAd.addEventListener(VPAIDEvent.AdVideoThirdQuartile, function():void {
				console("AdVideoThirdQuartile");
                onAdVideoThirdQuartile();
            });
			

			console("handshake");
            _vpaidAd.handshakeVersion("2.0");

			console("initAd");
            // Use stage rect because current ad implementations do not currently provide width/height.
            _vpaidAd.initAd(_model.stageRect.width, _model.stageRect.height, "normal", _model.bitrate, _model.adParameters);
			
			console("Timeout set to: " + _adResponseTimeoutDelay);
			if (_adResponseTimeoutDelay == -1) {
				console("Skipping ad timeout");
			}
			else {
				_adTimeout = new Timer(_adResponseTimeoutDelay);
				_adTimeout.addEventListener("timer", adResponseTimeoutFn);
				_adTimeout.start();
			}
        }
		
		public function adResponseTimeoutFn(event:TimerEvent): void {
			console("Ad Wait Timeout! Ending Ad!");
			clearTimeout();
			_model.broadcastErrorEventExternally(VPAIDEvent.AdTimeoutError);
			abortAd();
		}
		
		public function clearTimeout(): void {
			_adTimeout.stop();
			console("Timeout cleared!");
		}
    }
}