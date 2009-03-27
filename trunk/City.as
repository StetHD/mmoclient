﻿package
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	
	import CityImage;
	
	public class City extends Entity
	{
		public static var TYPE:int = Entity.CITY;
		public static var onClick:String = "onCityClick";	
		public static var onDoubleClick:String = "onCityDoubleClick";
		
		public var buildings:Array;
		
		public function City() : void
		{
			buildings = new Array();
		}
		
		override public function initialize() : void
		{
			var imageData:BitmapData = null;
			
			imageData = new CityImage(0,0);
			
			this.image = new Bitmap(imageData);
			this.addChild(this.image);	
		}
		
		override protected function mouseClick(e:Event) : void
		{
			trace("City - mouseClick");			
			var pEvent:ParamEvent = new ParamEvent(City.onClick);
			pEvent.params = this;
			
			Game.INSTANCE.dispatchEvent(pEvent);
		}
		
		override protected function mouseDoubleClick(e:Event) : void
		{
			trace("City - mouseDoubleClick");
			var pEvent:ParamEvent = new ParamEvent(City.onDoubleClick);
			pEvent.params = this;
						
			Game.INSTANCE.dispatchEvent(pEvent);
		}		
	}
}