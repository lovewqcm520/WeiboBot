package
{
	import com.jack.weibobot.Common;
	import com.jack.weibobot.WeiboCenter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="320", height="480")]
	public class WeiboBot extends Sprite
	{
		public function WeiboBot()
		{
			if(stage)
				init(null);
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:Event=null):void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Common.stage = stage;
			Common.stageWidth = stage.stageWidth;
			Common.stageHeight = stage.stageHeight;
			
			WeiboCenter.getInstance().showLogin();
		}
	}
}