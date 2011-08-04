﻿package ui 
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.entity.City;
	import game.Contract;
	
	public class QueueMarketUI extends MovieClip 
	{
		public static var QUEUE_START_X:int = 0;
		public static var QUEUE_START_Y:int = 18;		
		
		public static var MARKET_INFO_Y_TOP:int = 19;
		public static var MARKET_INFO_Y_BOTTOM:int = 327;
		
		public var city:City;
		
		public var queueInfo:MovieClip;
		public var marketInfo:MovieClip;
		
		private var queueEntryUIList:Array;
		
		public function QueueMarketUI() 
		{
			queueEntryUIList = new Array();
			
			queueInfo.addEventListener(MouseEvent.CLICK, queueInfoClick);
			marketInfo.addEventListener(MouseEvent.CLICK, marketInfoClick);
		}
		
		public function init() : void
		{
			bottomMarketInfo();
			clearInfo();
			setQueueEntries();
		}
		
		public function getQueueEntry(contractId:int) : QueueEntryUI
		{
			for(var i:int = 0; i < queueEntryUIList.length; i++)
			{
				var queueEntryUI:QueueEntryUI = QueueEntryUI(queueEntryUIList[i]);
				var contract:Contract = queueEntryUI.getContract();
				
				if(contract.id == contractId)
					return queueEntryUI;
				
			}
			
			return null;			
		}		
		
		private function queueInfoClick(e:MouseEvent) : void
		{
			clearInfo();
			bottomMarketInfo();
			
			setQueueEntries();
		}
		
		private function marketInfoClick(e:MouseEvent) : void
		{
			clearInfo();
			topMarketInfo();
		}
		
		private function topMarketInfo() : void
		{
			marketInfo.y = MARKET_INFO_Y_TOP;
		}
		
		private function bottomMarketInfo() : void
		{
			marketInfo.y = MARKET_INFO_Y_BOTTOM;
		}		
		
		private function setQueueEntries() : void
		{
			for(var i:int = 0; i < city.contracts.length; i++)
			{								
				var contract:Contract = Contract(city.contracts[i]);
				var queueEntryUI:QueueEntryUI = new QueueEntryUI();
				queueEntryUI.city = city;
				queueEntryUI.setQueueEntry(contract);
				queueEntryUI.x = QUEUE_START_X;				
				queueEntryUI.y = QUEUE_START_Y + i * queueEntryUI.height;
												
				queueEntryUIList.push(queueEntryUI);				
				
				addChild(queueEntryUI);
			}
		}		
		
		
		private function clearInfo() : void
		{
			removeQueueEntries();
		}		
		
		private function removeQueueEntries() : void
		{			
			if(queueEntryUIList != null)
			{
				for(var i = 0; i < queueEntryUIList.length; i++)
				{
					if(this.contains(queueEntryUIList[i]))
						this.removeChild(queueEntryUIList[i]);					
				}
				
				queueEntryUIList.length = 0;
			}
		}
		
		
	}
	
}
