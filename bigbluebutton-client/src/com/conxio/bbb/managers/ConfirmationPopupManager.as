package com.conxio.bbb.managers
{
	import com.conxio.bbb.views.ConfirmationPopup;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class ConfirmationPopupManager
	{
		private static var _instance:ConfirmationPopupManager;
		
		private var popupInstance:ConfirmationPopup;
		public function ConfirmationPopupManager()
		{
		}
		
		public static function get instance():ConfirmationPopupManager
		{
			if (!_instance)
				_instance = new ConfirmationPopupManager();
			return _instance;
		}
		
		public function show(message:String, confirmCallBack:Function):void
		{
			if (popupInstance)
				closePopup();
			popupInstance = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, ConfirmationPopup, true) as ConfirmationPopup;
			PopUpManager.centerPopUp(popupInstance);
			popupInstance.message = message;
			popupInstance.closeCallBack = confirmCallBack;
			popupInstance.addEventListener(CloseEvent.CLOSE, onPopupClose);
		}
		
		private function onPopupClose(event:CloseEvent):void
		{
			closePopup();
		}
		
		private function closePopup():void
		{
			PopUpManager.removePopUp(popupInstance);
			popupInstance = null;
		}
	}
}