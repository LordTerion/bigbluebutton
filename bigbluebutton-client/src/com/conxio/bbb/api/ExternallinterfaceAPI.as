package com.conxio.bbb.api
{
	import com.conxio.bbb.managers.ConfirmationPopupManager;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.core.model.MeetingModel;

	public class ExternallinterfaceAPI
	{
		private static var initializationComplete:Boolean;

		public function ExternallinterfaceAPI()
		{
		}

		public static function initCallBacks():void
		{
			if (ExternalInterface.available)
			{
//				ExternalInterface.addCallback("receiveAPIMessage", handleReceiveAPIMessage);
				ExternalInterface.addCallback("connectConfirmationRequest", handleConnectConfirmationRequestMessage);
				ExternalInterface.addCallback("forwardConfirmationRequest", handleForwardConfirmationRequestMessage);
				ExternalInterface.addCallback("forwardClientEvent", handleforwardClientEventMessage);
				ExternalInterface.addCallback("inviteConfirmationRequest", handleInviteConfirmationRequestMessage);
				ExternalInterface.addCallback("inviteOperatorEvent", handleInviteOperatorEvent);
			}
		}
		
		private static function handleInviteOperatorEvent(message:Object):void
		{
			var urlReq:URLRequest = new URLRequest(message.link);
			navigateToURL(urlReq);
		}
		
		private static function handleInviteConfirmationRequestMessage():void
		{
			ConfirmationPopupManager.instance.show("Operator ask you to join him", sendInviteConfirmationResponse);
			/*
			Alert.yesLabel = "Accept";
			Alert.noLabel = "Reject";
			Alert.show("Operator ask you to join him", "Please confirm", Alert.YES | Alert.NO, null, alertCloseHandler);
			function alertCloseHandler(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					sendInviteConfirmationResponse(true);
				}
				else
				{
					sendInviteConfirmationResponse(false);
				}
				Alert.yesLabel = "YES";
				Alert.noLabel = "NO";
			}*/
		}
		
		private static function handleforwardClientEventMessage(message:Object):void
		{
//			var obj:Object = JSON.parse(message);
			var urlReq:URLRequest = new URLRequest(message.link);
			navigateToURL(urlReq, "_self");
		}
		
		public static function init():void
		{
			if (ExternalInterface.available)
			{
				if (!initializationComplete)
				{
					var curUserID:String=UserManager.getInstance().getConference().getMyExternalUserID();
					var underscoreIndex:int = curUserID.indexOf("_");
					var userType:String = curUserID.substring(0, underscoreIndex);
					var userID:String = curUserID.substring(underscoreIndex + 1);
					var socketUrl:String = MeetingModel.getInstance().meeting.customDataObj.socketURL;
					ExternalInterface.call("initSocketAPI", userID, userType, socketUrl);
					initializationComplete=true;
				}
			}
		}
		
		private static function handleConnectConfirmationRequestMessage():void
		{
			ConfirmationPopupManager.instance.show("Client request connection", sendConnectionConfirmationResponse);
			/*
			Alert.yesLabel = "Accept";
			Alert.noLabel = "Reject";
			Alert.show("Client request connection", "Please confirm", Alert.YES | Alert.NO, null, alertCloseHandler);
			function alertCloseHandler(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					sendConnectionConfirmationResponse(true);
				}
				else
				{
					sendConnectionConfirmationResponse(false);
				}
				Alert.yesLabel = "YES";
				Alert.noLabel = "NO";
			}*/
		}
		
		private static function handleForwardConfirmationRequestMessage():void
		{
			ConfirmationPopupManager.instance.show("Operator wants to forward a call to you", sendForwardConfirmationResponse);
			/*
			Alert.yesLabel = "Accept";
			Alert.noLabel = "Reject";
			Alert.show("Operator wants to forward a call to you", "Please confirm", Alert.YES | Alert.NO, null, alertCloseHandler);
			function alertCloseHandler(event:CloseEvent):void
			{
				if (event.detail == Alert.YES)
				{
					sendForwardConfirmationResponse(true);
				}
				else
				{
					sendForwardConfirmationResponse(false);
				}
				Alert.yesLabel = "YES";
				Alert.noLabel = "NO";
			}
			*/
		}
		
		
		public static function sendConnectionConfirmationResponse(result:Boolean):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("connectionConfirmationResponse", result);
			}
		}
		
		public static function sendForwardConfirmationResponse(result:Boolean):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("forwardConfirmationResponse", result);
			}
		}
		
		public static function sendInviteConfirmationResponse(result:Boolean):void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.call("inviteConfirmationResponse", result);
			}
		}
	}
}
