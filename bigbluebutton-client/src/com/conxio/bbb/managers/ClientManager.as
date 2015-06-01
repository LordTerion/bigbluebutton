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
	import org.bigbluebutton.core.model.MeetingModel;
	import org.bigbluebutton.core.model.users.UsersModel;
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
				sendPersonLeave(UserManager.getInstance().getConference().getMyExternalUserID(), onComplete);
				function onComplete():void
				{
					UserManager.getInstance().getConference().removeAllParticipants();
					var logoutURL:String = MeetingModel.getInstance().meeting.customDataObj.logoutURLClient;
					navigateToURL(new URLRequest(logoutURL), "_self");
				}
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
			var isClient:Boolean = userID.toLowerCase().indexOf("client") != -1;
			var isOperatorMode:Boolean = UsersModel.getInstance().me.isOperator;
			if (usersHash.hasOwnProperty(userID))
				return;
			usersHash[userID] = new Date().getTime();
			logMessage("user with ID=" + userID + " joined.");
			if (isClient && isOperatorMode)
			{
				var index:int = userID.indexOf("_");
				userID = userID.substr(index + 1);
				MainServiceAPI.clientJoinMsg(userID);
			}
		} 
		
		private function userLeft(userID:String):void{
			var isClient:Boolean = userID.toLowerCase().indexOf("client") != -1;
			var isOperatorMode:Boolean = UsersModel.getInstance().me.isOperator;
			if (!usersHash.hasOwnProperty(userID))
				return;
			delete usersHash[userID];
			if (isClient && isOperatorMode)
			{
				sendPersonLeave(userID);
			}
		}
		
		private function sendPersonLeave(userID:String, callBack:Function = null):void
		{
			var oldTime:Number = usersHash[userID];
			var index:int = userID.indexOf("_");
			userID = userID.substr(index + 1);
			var nowTime:Number = new Date().getTime();
			var duration:Number = nowTime - oldTime;
			var seconds:int = (duration/1000)%60;
			var minutes:int=(duration/(1000*60))%60;
			var hours:int=(duration/(1000*60*60))%24;
			logMessage("user with ID=" + userID + " has left.");
			logMessage("user with ID=" + userID + " spent " + hours + ":" + minutes + ":" + seconds);
			MainServiceAPI.personLeaveMsg(userID, nowTime, duration, callBack);
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