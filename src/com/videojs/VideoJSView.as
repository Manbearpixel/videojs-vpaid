package com.videojs{
    
    import com.videojs.events.*;
    import flash.display.Sprite;
    import com.videojs.vpaid.AdContainer;
    
    public class VideoJSView extends Sprite{

        private var _uiBackground:Sprite;
        
        private var _model:VideoJSModel;
        
        public function VideoJSView(){
            
            _model = VideoJSModel.getInstance();
            _model.addEventListener(VideoJSEvent.BACKGROUND_COLOR_SET, onBackgroundColorSet);
            _model.addEventListener(VideoJSEvent.STAGE_RESIZE, onStageResize);

            _uiBackground = new Sprite();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
            _uiBackground.alpha = _model.backgroundAlpha;
            addChild(_uiBackground);

            _model.adContainer = new AdContainer();
            addChild(_model.adContainer);
        }


        private function onBackgroundColorSet(e:VideoPlaybackEvent):void{
            _uiBackground.graphics.clear();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
        }
        
        private function onStageResize(e:VideoJSEvent):void{
            
            _uiBackground.graphics.clear();
            _uiBackground.graphics.beginFill(_model.backgroundColor, 1);
            _uiBackground.graphics.drawRect(0, 0, _model.stageRect.width, _model.stageRect.height);
            _uiBackground.graphics.endFill();
            _model.adContainer.resize(_model.stageRect.width, _model.stageRect.height)
        }
        
    }
}