package com.conxio.bbb.services
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	public class MainServiceAPI
	{
		public static var kioskServerURL:String = "http://streaming.conx.io:40001";
		public static var operatorServerURL:String = "http://streaming.conx.io:40002";
		
		public static function changeCallCenterOperatorAvailabilityMsg(operatorId:String, callCenerId:String, status:int, callBack:Function):void
		{
			var urlReq:URLRequest = new URLRequest(operatorServerURL + "/api/operator/changeCallCenterOperatorAvailability");
			urlReq.method = URLRequestMethod.POST;
			var requestVars:URLVariables = new URLVariables();
			requestVars.OperatorId = operatorId;
			requestVars.CallCenterId = operatorId;
			requestVars.CallCenterOperatorStatus = status;
			urlReq.data = requestVars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				if (callBack != null)
					callBack(urlLoader.data);
			}
		}
		
		public static function clientJoinMsg(clientID:String):void
		{
			var urlReq:URLRequest = new URLRequest(kioskServerURL + "/api/manage/kiosk/flashApi/updateClientSession");
			urlReq.method = URLRequestMethod.POST;
			var requestVars:URLVariables = new URLVariables();
			requestVars.SessionUid = clientID;
			urlReq.data = requestVars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				
			}
		}
		
		public static function clientLeaveMsg(clientID:String, endTime:Number, duration:Number):void
		{
			var urlReq:URLRequest = new URLRequest(kioskServerURL + "/api/manage/kiosk/flashApi/closeClientSession");
			urlReq.method = URLRequestMethod.POST;
			var requestVars:URLVariables = new URLVariables();
			requestVars.SessionUid = clientID;
			requestVars.EndTime = endTime;
			requestVars.Duration = duration;
			urlReq.data = requestVars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				
			}
		}
		
		public static function getCallCentersMsg(operatorID:String, callBack:Function):void
		{
			var urlReq:URLRequest = new URLRequest(operatorServerURL + "/api/operator/getCallCentersOfOperatorById");
			urlReq.method = URLRequestMethod.GET;
			var requestVars:URLVariables = new URLVariables();
			requestVars.Id = operatorID;
			urlReq.data = requestVars;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				callBack(urlLoader.data);
			}
		}
		
		public static function getListOfFreeOperators(callBack:Function):void
		{
			var urlReq:URLRequest = new URLRequest(operatorServerURL + "/api/operator/getListOfFreeOperators");
			urlReq.method = URLRequestMethod.POST;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				if (callBack != null)
					callBack(urlLoader.data);
			}
		}
		
		public static function forwardCallToOperator(operatorID:String, clientID:String, callBack:Function):void
		{
			var urlReq:URLRequest = new URLRequest(kioskServerURL + "/api/manage/kiosk/forwardTo");
			urlReq.method = URLRequestMethod.GET;
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.Id = operatorID;
			requestVars.clientId = clientID;
			urlReq.data = requestVars;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				if (callBack != null)
					callBack(urlLoader.data);
			}
		}
		
		public static function inviteOperator(operatorID:String, inviteOwnerID:String, callBack:Function):void
		{
			var urlReq:URLRequest = new URLRequest(kioskServerURL + "/api/manage/kiosk/inviteOperator");
			urlReq.method = URLRequestMethod.GET;
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.Id = operatorID;
			requestVars.inviteOwnerId = inviteOwnerID;
			urlReq.data = requestVars;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			try
			{
				urlLoader.load(urlReq);
			} 
			catch(error:Error) 
			{
				
			}
			
			function onComplete(event:Event):void
			{
				if (callBack != null)
					callBack(urlLoader.data);
			}
		}

		public function MainServiceAPI() 
		{
		}
	}
}