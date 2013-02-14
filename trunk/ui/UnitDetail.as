﻿package ui {		import flash.display.MovieClip;	import fl.text.TLFTextField;	import flash.events.MouseEvent;	import game.unit.Unit;	import game.Item;	import stats.UnitTemplate;	import stats.UnitRecipe;	import game.Game;	import game.Kingdom;	import game.KingdomManager;	import game.Population;		public class UnitDetail extends MovieClip 	{		public static var SPACER_X:int = 4;		public static var INV_OFFSET_X:int = 27;		public static var INV_OFFSET_Y:int = 78;		public static var INV_NUM_X:int = 4;		public static var INV_NUM_Y:int = 3;		public static var MELEE_1H:String = "Melee Weapon (1H)";		public static var MELEE_2H:String = "Melee Weapon (2H)";		public static var RANGE_1H:String = "Ranged Weapon (1H)";		public static var RANGE_2H:String = "Ranged Weapon (2H)";		public static var OFFHAND:String = "Offhand";		public static var LIGHT_ARMOR:String = "Light Armor";		public static var MEDIUM_ARMOR:String = "Medium Armor";		public static var HEAVY_ARMOR:String = "Heavy Armor";				public var unitDetailStats:UnitDetailStats;		public var gear:UnitDetailGear;		public var inventory:UnitDetailInventory;				public var unit:Unit;				public var unitNameText:TLFTextField;		public var unitTypeText:TLFTextField;				public var statsText:TLFTextField;		public var gearText:TLFTextField;		public var abilitiesText:TLFTextField;		public var inventoryText:TLFTextField;				public var closeButton:CloseButton;				private var unitTemplate:UnitTemplate;		private var unitRecipe:UnitRecipe;				private var itemIcons:Array;		private var gearIcons:Array;				public function UnitDetail() 		{					}				public function init(): void		{			this.visible = false;						itemIcons = new Array();			gearIcons = new Array();						statsText.addEventListener(MouseEvent.CLICK, statsClick);			gearText.addEventListener(MouseEvent.CLICK, gearClick);			inventoryText.addEventListener(MouseEvent.CLICK, inventoryClick);						closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);		}				public function setUnit(unit:Unit): void		{			this.unit = unit;		}				public function showPanel() : void		{			this.parent.setChildIndex(this, this.parent.numChildren - 1);				this.visible = true;						setStats();			setGear();			setInventory();		}				private function setStats() : void		{			var kingdom:Kingdom = KingdomManager.INSTANCE.getKingdom(Game.INSTANCE.player.id);			unitRecipe = kingdom.getUnitRecipe(unit.recipeId);						trace("unitRecipe TemplateId: " + unitRecipe.templateId);						unitTemplate = Stats.INSTANCE.getUnitTemplate(unitRecipe.templateId);						trace("unitTemplate:  " + unitTemplate);						unitNameText.text = unitRecipe.unitName;			unitTypeText.text = unitTemplate.name;						unitDetailStats.atk.text = unitTemplate.atk.toString();			unitDetailStats.def.text = unitTemplate.def.toString();			unitDetailStats.range.text = unitTemplate.range.toString();			unitDetailStats.acc.text = unitTemplate.acc.toString();			unitDetailStats.eva.text = unitTemplate.eva.toString();			unitDetailStats.speed.text = unitTemplate.speed.toString();			unitDetailStats.movement.text = unitTemplate.movement.toString();									setUnitAmountIcon();		}				private function setGear() : void		{			trace("UnitDetail unit.gear: " + unit.gear.length)			for(var i:int = 0; i < unit.gear.length; i++)			{				var itemId:int = unit.gear[i];				var item:Item = getItem(itemId);								if(item != null)				{					trace("UnitDetail item.getCategory: " + item.getCategory())					switch(item.getCategory())					{						case MELEE_1H:						case RANGE_1H:							setGearIcon(item, 0, 1);							break;						case MELEE_2H:						case RANGE_2H:							setGearIcon(item, 0, 1);							setGearIcon(item, 0, 51);							break;						case OFFHAND:							setGearIcon(item, 0, 51);							break;						case LIGHT_ARMOR:						case MEDIUM_ARMOR:						case HEAVY_ARMOR:							setGearIcon(item, 0, 101);							break;					}				}			}		}				private function setGearIcon(item:Item, xPos:int, yPos:int) : void		{			var iconItem:IconItem = new IconItem();			iconItem.setItem(item);			iconItem.x = xPos;			iconItem.y = yPos;			iconItem.anchorX = iconItem.x;			iconItem.anchorY = iconItem.y;							gear.addChild(iconItem);						gearIcons.push(iconItem);								}				private function getItem(itemId:int) : Item		{			for(var i:int = 0; i < unit.items.length; i++)			{				var item:Item = Item(unit.items[i]);				trace("itemId: " + itemId + " item.id: "+  item.id)				if(itemId == item.id)				{					return item;				}			}						return null;		}				private function setInventory() : void		{			trace("UnitDetail - unit.items: " + unit.items.length);						for(var i:int = 0; i < unit.items.length; i++)			{				var item:Item = Item(unit.items[i]);								var iconItem:IconItem = new IconItem();				iconItem.setItem(item);				iconItem.x = INV_OFFSET_X + (i % INV_NUM_X) * (iconItem.width + SPACER_X);				iconItem.y = INV_OFFSET_Y + int(i / INV_NUM_Y) * (iconItem.height + SPACER_X);				iconItem.anchorX = iconItem.x;				iconItem.anchorY = iconItem.y;													inventory.addChild(iconItem);								itemIcons.push(iconItem);							}		}				private function setUnitAmountIcon() : void		{			var race:int = getRace();			var raceName:String = Population.getRaceName(race);									var raceIcon:MovieClip = Population.createRaceIcon(race);						raceIcon.x = 1;			raceIcon.y = 1;						unitDetailStats.unitAmountIcon.amountRaceText.text = unit.size + " " + raceName;			unitDetailStats.unitAmountIcon.casteText.text = "";			unitDetailStats.unitAmountIcon.addChild(raceIcon);						unitDetailStats.unitAmountIcon.removeButton.visible = false;		}				private function getRace() : int		{			if(unitTemplate.name.indexOf("Human") != -1)			{				return Population.RACE_HUMAN;			}			else if(unitTemplate.name.indexOf("Dwarven") != -1)			{				return Population.RACE_DWARF;			}			else if(unitTemplate.name.indexOf("Elven") != -1)			{				return Population.RACE_ELF;			}			else if(unitTemplate.name.indexOf("Goblin") != -1)			{				return Population.RACE_GOBLIN;			}									return -1;		}				private function statsClick(e:MouseEvent) : void		{			unitDetailStats.visible = true;			gear.visible = false;			inventory.visible = false;		}				private function gearClick(e:MouseEvent) : void		{			unitDetailStats.visible = false;			gear.visible = true;			inventory.visible = false;		}				private function inventoryClick(e:MouseEvent) : void		{			unitDetailStats.visible = false;			gear.visible = false;			inventory.visible = true;		}				private function closeButtonClick(e:MouseEvent) : void		{			this.visible = false;		}			}	}