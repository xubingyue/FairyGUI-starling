package fairygui
{
	import flash.geom.Rectangle;
	
	import fairygui.display.MovieClip;
	import fairygui.display.UIMovieClip;
	import fairygui.utils.ToolSet;
	
	public class GMovieClip extends GObject implements IAnimationGear, IColorGear
	{			
		private var _movieClip:MovieClip;
		
		public function GMovieClip()
		{
			_sizeImplType = 1;
		}
		
		public function get color():uint
		{
			return _movieClip.color;
		}
		
		public function set color(value:uint):void
		{
			_movieClip.color = value;
			updateGear(4);
		}
		
		override protected function createDisplayObject():void
		{
			_movieClip = new UIMovieClip(this);
			setDisplayObject(_movieClip);
		}
		
		final public function get playing():Boolean
		{
			return _movieClip.playing;
		}
		
		final public function set playing(value:Boolean):void
		{
			if(_movieClip.playing!=value)
			{
				_movieClip.playing = value;
				updateGear(5);
			}
		}
		
		final public function get frame():int
		{
			return _movieClip.currentFrame;
		}
		
		public function set frame(value:int):void
		{
			if(_movieClip.currentFrame!=value)
			{
				_movieClip.currentFrame = value;
				updateGear(5);
			}
		}
		
		//从start帧开始，播放到end帧（-1表示结尾），重复times次（0表示无限循环），循环结束后，停止在endAt帧（-1表示参数end）
		public function setPlaySettings(start:int = 0, end:int = -1, 
										times:int = 0, endAt:int = -1, 
										endCallback:Function = null):void
		{
			_movieClip.setPlaySettings(start, end, times, endAt, endCallback);	
		}

		override public function constructFromResource(pkgItem:PackageItem):void
		{
			_packageItem = pkgItem;
			
			_sourceWidth = _packageItem.width;
			_sourceHeight = _packageItem.height;
			_initWidth = _sourceWidth;
			_initHeight = _sourceHeight;

			setSize(_sourceWidth, _sourceHeight);
			
			if(_packageItem.loaded)
				__movieClipLoaded(_packageItem);
			else
				_packageItem.owner.addItemCallback(_packageItem, __movieClipLoaded);
		}
		
		private function __movieClipLoaded(pi:PackageItem):void
		{
			_movieClip.interval = _packageItem.interval;
			_movieClip.swing = _packageItem.swing;
			_movieClip.repeatDelay = _packageItem.repeatDelay;
			_movieClip.frames = _packageItem.frames;
			_movieClip.boundsRect = new Rectangle(0, 0, sourceWidth, sourceHeight);
		}

		override public function setup_beforeAdd(xml:XML):void
		{
			super.setup_beforeAdd(xml);
			
			var str:String;
			str = xml.@frame;
			if(str)
				_movieClip.currentFrame = parseInt(str);
			str = xml.@playing;
			_movieClip.playing = str!= "false";
			str = xml.@color;
			if(str)
				this.color = ToolSet.convertFromHtmlColor(str);
		}
	}
}