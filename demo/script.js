var videoPoster     = "http://assets2.touchvision.com/video/724e2682-af3d-4212-a7c8-3cf80fdba7d7/tv_724e2682-af3d-4212-a7c8-3cf80fdba7d7_1024.jpg";
var videoFile       = "http://assets2.touchvision.com/video/724e2682-af3d-4212-a7c8-3cf80fdba7d7/mp4/1200k/724e2682-af3d-4212-a7c8-3cf80fdba7d7.mp4";

// Flash Debug
var vpaidFlashDebug = false;
setFlashDebug();
function setFlashDebug() {
	document.getElementById("toggleFlashDebug").innerHTML = vpaidFlashDebug;
}
function toggleFlashDebug() {
	vpaidFlashDebug = !vpaidFlashDebug;
	setFlashDebug();
}

function refreshPage() {
	location.reload();
}

function setVPAID(vpaidURL) {
	document.getElementById("vpaid_url").value = vpaidURL;
}

window.vjsPlayerVPAID = null;
function runVPAIDAlt() {
    console.log("[js] Running Player with ALT VPAID Ad URL: " + document.getElementById("vpaid_url").value);

	// Personal way of setting html5 or flash, NOT REQUIRED
	var techOptions = ["html5", "flash"];
	if (/firefox/i.test(navigator.userAgent) === true) {
		techOptions = ["flash", "html5"];
	}
	
    window.vjsPlayerVPAID = videojs("player", {
      techOrder : techOptions,
      controls  : true,
      autoplay  : false,
      poster    : videoPoster,
      plugins   : {
        vjsVPAID : {
            vpaidSWF: '/dist/videojs-vpaid.swf',
            vpaidUrl: document.getElementById("vpaid_url").value,
            debug: vpaidFlashDebug
        }
      }
	}, function(){

		player = this;

		// Dynamically add video source and poster (personal preference, not required)
		player.src({
			src   : videoFile,
			type  : "video/mp4"
		});
		player.poster(videoPoster);
		

		/*
		Player Events
		*/
		player.on("ended", function(event){
			console.log("[VJS] video end");
		});

		player.on("play", function(event){
			console.log("[VJS] video play");
		});

		player.on("pause", function(event){
			console.log("[VJS] video pause");
		});

		player.on("loadstart", function(event){
			console.log("[VJS] video loadstart");
		});


		/*
		VPAID Ad Events
		*/
		
		// Start ups
		player.on("vpaid_AdStarted", function(event){
			console.log("[VJS] ad started");
		});
		
		player.on("vpaid_AdLoaded", function(event){
			console.log("[VJS] ad loaded");
		});
		
		// Interactions
       	player.on("vpaid_AdClickThru", function(event){
			console.log("[VJS] ad clickthru");
		});
		
		// Errors
		player.on("vpaid_AdTimeoutError", function(event){
			console.log("[VJS] ad timeout");
		});
		
       	player.on("vpaid_error", function(event){
			console.log("[VJS] ad error");
		});
		
		// Ad Duration
		player.on("vpaid_AdVideoFirstQuartile", function(event){
			console.log("[VJS] ad first quarter");
		});
		
		player.on("vpaid_AdVideoMidpoint", function(event){
			console.log("[VJS] ad midpoint");
		});
		
		player.on("vpaid_AdVideoThirdQuartile", function(event){
			console.log("[VJS] ad third quarter");
		});
		
       	player.on("vpaid_AdComplete", function(event){
			console.log("[VJS] ad complete");
		});
		
		// Ad Playback
		player.on("vpaid_AdPlaying", function(event){
			console.log("[VJS] ad playing");
		});
		
		player.on("vpaid_AdPaused", function(event){
			console.log("[VJS] ad paused");
		});
		
	});

}