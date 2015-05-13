package com.conxio.bbb.managers
{
	import com.asfusion.mate.events.Dispatcher;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.bigbluebutton.main.events.BBBEvent;
	import org.bigbluebutton.main.events.UserJoinedEvent;
	import org.bigbluebutton.main.events.UserLeftEvent;
	
	public class ClientManager
	{
		private var dispatcher:Dispatcher;
		public static var logText:String = "";
		private var usersHash:Object;

		public function ClientManager(){
			dispatcher = new Dispatcher();
			usersHash = {};
		}
		
		public function handleUserJoined(event:UserJoinedEvent):void{
			var userID:String = event.userID;
			userJoined(userID);
		}

		public function handleUserLeft(event:UserLeftEvent):void{
			var userID:String = event.userID;
			userLeft(userID);
		}
		
		public function handleUserVoiceJoin(event:BBBEvent):void{
			var userID:String = event.message;
			userJoined(userID);
		}
		
		public function handleUserVoiceLeft(event:BBBEvent):void{
			var userID:String = event.message;
			userLeft(userID);
		}
		
		private function userJoined(userID:String):void{
			if (usersHash.hasOwnProperty(userID))
				return;
			usersHash[userID] = new Date().getTime();
			logMessage("user with ID=" + userID + " joined.");
		}
		
		private function userLeft(userID:String):void{
			if (!usersHash.hasOwnProperty(userID))
				return;
			var oldTime:Number = usersHash[userID];
			var nowTime:Number = new Date().getTime();
			var spentTime:Number = nowTime - oldTime;
			var seconds:int = (spentTime/1000)%60;
			var minutes:int=(spentTime/(1000*60))%60;
			var hours:int=(spentTime/(1000*60*60))%24;
			logMessage("user with ID=" + userID + " has left.");
			logMessage("user with ID=" + userID + " spent " + hours + ":" + minutes + ":" + seconds);
			var urlReq:URLRequest = new URLRequest("http://192.168.72.129:40001/api/manage/kiosk/:sendKioskStats");
			urlReq.method = URLRequestMethod.GET;
			var requestVars:URLVariables = new URLVariables();
			requestVars.UserDuration = spentTime;
			urlReq.data = requestVars;
//			urlReq.data = "UserDuration="+spentTime;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE,  function(event:Event):void{
				trace();
			});
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		private function logMessage(message:String):void
		{
			logText += message + "\n";
		}
	}
}