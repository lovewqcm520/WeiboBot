package com.jack.weibobot
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.sina.microblog.events.WeiboServiceEvent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class WeiboCenter
	{
		//申请应用的app key
		private var _appKey:String = "1104843535";
		
		private var webView:StageWebView;
		private var _mb:MicroBlog;
		private var uid:String;
		private var access_token:String;
		private var expires_in:String;
		private var remind_in:String;
		
		
		private static var _instance:WeiboCenter;

		private var date:Date;
		
		public function WeiboCenter()
		{
		}
		
		public static function getInstance():WeiboCenter
		{
			if(!_instance)
				_instance = new WeiboCenter();
			
			return _instance;
		}
		
		private function initWeibo():void
		{
			_mb = new MicroBlog();
			_mb.access_token = access_token;
			_mb.consumerKey = "1104843535";
			_mb.consumerSecret = "6abc114262e5f3ac9e2c84cf6714091b";
			_mb.expires_in = expires_in;
			
			_mb.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, onUpdateStatusResult);
			_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginResult);
			
			_mb.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, onUpdateStatusError);
			_mb.addEventListener(MicroBlogErrorEvent.LOGIN_ERROR, onLoginError);
			
			_mb.addEventListener(WeiboServiceEvent.UPDATE_RESULT, onUpdateResult);
			_mb.addEventListener(WeiboServiceEvent.UPDATE_ERROR, onUpdateError);
			
			_mb.loginResult(access_token, expires_in);
			
			//创建一个对象，用与保存请求接口的参数
			var obj:Object = {};
			//这个接口只需要一个参数，uid或者screen_name
			obj.uid = uid;
			//侦听成功调用的事件
//			_mb.addEventListener("onFriendsshipsResult", onFriendsshipsResult);
//			//侦听失败调用的事件
//			_mb.addEventListener("onFriendsshipsError", onFriendsshipsError);
//			//调用通用接口
//			_mb.callWeiboAPI("2/friendships/friends", obj, "GET",
//				"onFriendsshipsResult", "onFriendsshipsError");
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
//			// test 发送微博
//			date = new Date();
//			var str:String = "现在是" + date.hours + ":00点,Rose,我爱你，希望你能够嫁给我!" ;
//			//str += " at " + new Date().toString() + " !";
//			_mb.updateStatus(str);
//			trace(str);
		}
		
		protected function onUpdateError(event:WeiboServiceEvent):void
		{
			trace("onUpdateError");
		}
		
		protected function onUpdateResult(event:WeiboServiceEvent):void
		{
			trace("onUpdateResult");
		}
		
		protected function onLoginError(event:MicroBlogErrorEvent):void
		{
			trace("onUpdateResult", event.message);
		}
		
		protected function onUpdateStatusError(event:MicroBlogErrorEvent):void
		{
			trace("onUpdateStatusError", event.message);
		}
		
		protected function onLoginResult(event:MicroBlogEvent):void
		{
			trace("onLoginResult", event.result.access_token, event.result.expires_in, event.result.refresh_token);
		}
		
		protected function onUpdateStatusResult(event:MicroBlogEvent):void
		{
			trace("onUpdateStatusResult");
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			date = new Date();
			//trace(date.hours, date.minutes, date.seconds);
			if(date.minutes == 0 && date.seconds == 0)
			{
				//trace(date.hours, date.minutes, date.seconds);
				// test 发送微博
				var str:String = "现在是" + date.hours + ":00点,Rose,我爱你，希望你能够嫁给我!" ;
				//str += " at " + new Date().toString() + " !";
				_mb.updateStatus(str);
				trace(str);
			}
		}
		
		private function onFriendsshipsResult(e:MicroBlogEvent):void
		{
			//移除事件
			_mb.removeEventListener("onFriendsshipsResult", onFriendsshipsResult);
			_mb.removeEventListener("onFriendsshipsError", onFriendsshipsError);
			//获取结果
			trace("onFriendsshipsResult", e.result);
		}
		
		private function onFriendsshipsError(e:MicroBlogErrorEvent):void
		{
			//移除事件
			_mb.removeEventListener("onFriendsshipsResult", onFriendsshipsResult);
			_mb.removeEventListener("onFriendsshipsError", onFriendsshipsError);
			//获得错误信息
			trace("onFriendsshipsError", e.message);
		}
		
		public function showLogin():void
		{
			var url:String = "https://api.weibo.com/oauth2/authorize";
			url+="?client_id=" + _appKey;
			url += "&response_type=token";
			url += "&display=flash";
			
			webView = new StageWebView();
			var urlReq:URLRequest = new URLRequest(url);
			webView.addEventListener(Event.LOCATION_CHANGE, onLocationChange);
			webView.addEventListener(Event.COMPLETE, onComplete);
			webView.addEventListener(IOErrorEvent.IO_ERROR, onIoerror);
			webView.loadURL(url); 
			
			webView.stage = Common.stage;
			webView.viewPort = new Rectangle( 0, 0, Common.stageWidth, Common.stageHeight );
		}
		
		protected function onIoerror(event:IOErrorEvent):void
		{
			trace("IOErrorEvent");
		}
		
		protected function onComplete(event:Event):void
		{
			trace("onComplete", webView.title, webView.location);
		}
		
		protected function onLocationChange(event:Event):void
		{
			trace("onLocationChange", webView.title, webView.location);
			var lc:String = webView.location
			//授权成功的情况： 
			//https://api.weibo.com/oauth2/connect.html#access_token=2.00fOiXjBDXvUSCfcad38dcb00toA5Q&expires_in=604800&remind_in=60267&uid=1589102821
			//trace(lc);
			var arr:Array = String(lc.split("#")[1]).split("&");
			access_token = "";
			expires_in = "";
			remind_in = "";
			uid = "";
			var error:String = "";
			var error_code:String = "";
			var error_description:String = "";
			for (var i:int = 0 ; i < arr.length; i ++)
			{
				var str:String = arr[i];
				if (str.indexOf("access_token=") >= 0) access_token = str.split("=")[1];
				if (str.indexOf("expires_in=") >= 0) expires_in = str.split("=")[1];
				if (str.indexOf("remind_in=") >= 0) remind_in = str.split("=")[1];
				if (str.indexOf("uid=") >= 0) uid = str.split("=")[1];
				if (str.indexOf("error=") >= 0) error = str.split("=")[1];
				if (str.indexOf("error_code=") >= 0) error_code = str.split("=")[1];
				if (str.indexOf("error_description=") >= 0) error_description = str.split("=")[1];
			}
			
			if(access_token != "")
			{
				//说明登陆成功
				webView.removeEventListener(Event.LOCATION_CHANGE, onLocationChange);
				webView.dispose();
				webView = null;
				
				var result:String =  "-- access_token: " + access_token + "\n";
				result += "-- expires_in: " + expires_in + "\n";
				result += "-- remind_in: " + remind_in + "\n";
				result += "-- uid: " + uid;
				trace(result);
				
				initWeibo();
			}
			else
			{
				if(error != "")
				{
					trace(error, error_code, error_description);
				}
			}
			
		}
		
	}
	
}