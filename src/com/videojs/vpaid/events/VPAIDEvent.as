package com.videojs.vpaid.events {
    
    import flash.events.Event;
    
    public class VPAIDEvent extends Event {
        public function VPAIDEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false) {
            super(param1,param3,param4);
            this._data = param2;
        }
        
        private var _data:Object;
        
        public function get data() : Object {
            return this._data;
        }

        public static const AdLoaded : String = "AdLoaded";
        public static const AdStarted : String = "AdStarted";
        public static const AdStopped : String = "AdStopped";
        public static const AdSkipped : String = "AdSkipped";
		public static const AdComplete : String = "AdComplete";
        public static const AdLinearChange : String = "AdLinearChange";
        public static const AdSizeChange : String = "AdSizeChange";
        public static const AdExpandedChange : String = "AdExpandedChange";
        public static const AdSkippableStateChange : String = "AdSkippableStateChange";
        public static const AdRemainingTimeChange : String = "AdRemainingTimeChange";
        public static const AdDurationChange : String = "AdDurationChange";
        public static const AdVolumeChange : String = "AdVolumeChange";
        public static const AdImpression : String = "AdImpression";
        public static const AdVideoStart : String = "AdVideoStart";
        public static const AdVideoFirstQuartile : String = "AdVideoFirstQuartile";
        public static const AdVideoMidpoint : String = "AdVideoMidpoint";
        public static const AdVideoThirdQuartile : String = "AdVideoThirdQuartile";
        public static const AdVideoComplete : String = "AdVideoComplete";
        public static const AdClickThru : String = "AdClickThru";
        public static const AdInteraction : String = "AdInteraction";
        public static const AdUserAcceptInvitation : String = "AdUserAcceptInvitation";
        public static const AdUserMinimize : String = "AdUserMinimize";
        public static const AdUserClose : String = "AdUserClose";
        public static const AdPaused : String = "AdPaused";
        public static const AdPlaying : String = "AdPlaying";
        public static const AdLog : String = "AdLog";
        public static const AdError : String = "AdError";
        public static const AdVastCall: String = "AdVastCall";
		public static const AdCreativeError: String = "AdCreativeError";
    }
}