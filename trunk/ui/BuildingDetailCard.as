﻿package ui {
	
	import flash.display.MovieClip;
	import fl.text.TLFTextField;
	import flash.display.Bitmap;
	import flash.display.BitmapData;		
	
	import game.Assignment;
	import game.Population;
	import flash.events.MouseEvent;
	
	public class BuildingDetailCard extends MovieClip 
	{
		public var objectNameText:TLFTextField;
		public var objectFullNameText:TLFTextField;
		public var objectNameLevelText:TLFTextField;
		public var totalPopText:TLFTextField;
		public var hpText:TLFTextField;
		public var closeButton:MovieClip;
		
		public var castes:Array;
		
		private var raceIcons:Array;
		
		public function BuildingDetailCard() 
		{			
			castes = new Array();
			raceIcons = new Array();
		}				
		
		public function setAssignments(assignments:Array) : void
		{
			removeAssignments();
			
			castes = new Array();			
			
			for(var i:int = 0; i < assignments.length; i++)
			{
				var assignment:Assignment = Assignment(assignments[i]);
				var buildingCaste:BuildingCaste = new BuildingCaste();
				var race:String = Population.getRaceName(assignment.race);				
				var caste:String = Population.getCasteName(assignment.caste);
				var raceIcon:MovieClip = createRaceIcon(assignment.race);
				
				raceIcon.x = 2;
				raceIcon.y = 2;
				
				buildingCaste.assignmentId = assignment.id;
				buildingCaste.amountRaceText.text = assignment.amount + " " + race;
				buildingCaste.casteText.text = caste;
				buildingCaste.x = 11;
				buildingCaste.y = 274 + (i * 25);
				buildingCaste.addChild(raceIcon);
				buildingCaste.removeButton.addEventListener(MouseEvent.CLICK, removeButtonClick);
				
				addChild(buildingCaste);				
				
				castes.push(buildingCaste);
			}
		}
		
		public function setActiveContract(queueEntryUI:QueueEntryUI) : void
		{
			if(queueEntryUI != null)			
			{				
				addChild(queueEntryUI);
			}
		}
		
		private function removeButtonClick(e:MouseEvent) : void
		{			
			trace(e.target.parent);
			var buildingCaste:BuildingCaste = BuildingCaste(e.target.parent);			
		}
		
		private function createRaceIcon(race:int) : MovieClip
		{			
			var iconBitmapData:BitmapData = Population.getImage(race);
			var iconBitmap:Bitmap = new Bitmap(iconBitmapData);			
			var raceIcon = new MovieClip();
			raceIcon.addChild(iconBitmap);				
			
			return raceIcon;
		}						
				
		private function removeAssignments() : void
		{
			for(var i:int = 0; i < castes.length; i++)
			{
				for(var j:int = 0; j < raceIcons.length; j++)
				{
					if(castes[i].contains(raceIcons[j]))
						castes[i].removeChild(raceIcons[j]);					
				}				
				
				removeChild(castes[i]);
			}		
		}
	}
	
}
