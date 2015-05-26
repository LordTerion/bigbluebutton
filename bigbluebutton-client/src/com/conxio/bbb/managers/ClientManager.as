package com.conxio.bbb.managers
{
	import com.asfusion.mate.events.Dispatcher;
	import com.conxio.bbb.api.ExternallinterfaceAPI;
	import com.conxio.bbb.services.MainServiceAPI;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.events.BBBEvent;
	import org.bigbluebutton.main.events.UserJoinedEvent;
	import org.bigbluebutton.main.events.UserLeftEvent;
	import org.bigbluebutton.main.model.users.BBBUser;
	
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
			var userID:String = event.externUserID;
			userJoined(userID);
		}

		public function handleUserLeft(event:UserLeftEvent):void{
			var userID:String = event.externUserID;
			userLeft(userID);
		}
		
		public function handleOperatorLeft(event:UserLeftEvent):void{
			var userID:String = event.externUserID;
			if (userID.toLowerCase().indexOf("operator") != -1)
			{
				UserManager.getInstance().getConference().removeAllParticipants();
				navigateToURL(new URLRequest("http://streaming.conx.io:40001"));
			}
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
			if (userID.toLowerCase().indexOf("client") == -1)
				return;
			if (usersHash.hasOwnProperty(userID))
				return;
			userID = userID.substr(7);
			usersHash[userID] = new Date().getTime();
			logMessage("user with ID=" + userID + " joined.");
			MainServiceAPI.clientJoinMsg(userID);
		} 
		
		private function userLeft(userID:String):void{
			if (userID.toLowerCase().indexOf("client") == -1)
				return;
			userID = userID.substr(7);
			if (!usersHash.hasOwnProperty(userID))
				return;
			var oldTime:Number = usersHash[userID];
			var nowTime:Number = new Date().getTime();
			var duration:Number = nowTime - oldTime;
			var seconds:int = (duration/1000)%60;
			var minutes:int=(duration/(1000*60))%60;
			var hours:int=(duration/(1000*60*60))%24;
			logMessage("user with ID=" + userID + " has left.");
			logMessage("user with ID=" + userID + " spent " + hours + ":" + minutes + ":" + seconds);
			MainServiceAPI.clientLeaveMsg(userID, nowTime, duration);
		}
		
		public function checkIfOwnerJoined(event:UserJoinedEvent):void
		{
			var user:BBBUser = UserManager.getInstance().getConference().getUser(event.userID);
			if (user.me)
			{
				ExternallinterfaceAPI.init();
			}
		}
		
		private function logMessage(message:String):void
		{
			logText += message + "\n";
		}
	}
}