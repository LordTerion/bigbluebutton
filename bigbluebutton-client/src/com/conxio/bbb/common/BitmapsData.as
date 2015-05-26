package com.conxio.bbb.common
{
	[Bindable]
	public class BitmapsData
	{
		[Embed(source="assets/images/forwardIcon.png")]
		public static var forwardImageClass:Class;
		
		[Embed(source="assets/images/addOperatorIcon.png")]
		public static var addOperatorClass:Class;
		
		[Embed(source="assets/images/operatorIcon.png")]
		public static var operatorImageClass:Class;

		[Embed(source="assets/images/callCenterIcon.png")]
		public static var callCenterImageClass:Class;

		public function BitmapsData()
		{
		}
	}
}