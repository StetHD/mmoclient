﻿package  
{
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
		
	import stats.ImprovementStat;
	import stats.BuildingStat;
	import stats.ItemBase;
	import stats.ItemCategory;
	import stats.ItemStats;
	import stats.ItemTemplate;
	import stats.ItemRecipe;
	import stats.UnitTemplate;
	import stats.UnitRecipe;
	
	public class Stats 
	{
		public static var INSTANCE:Stats = new Stats();
		public static var DomainURL:String = "";

		public var improvementLoader:URLLoader = new URLLoader();
		public var buildingLoader:URLLoader = new URLLoader();
		public var itemLoader:URLLoader = new URLLoader();
		public var itemStatsLoader:URLLoader = new URLLoader();
		public var itemCategoryLoader:URLLoader = new URLLoader();
		public var itemTemplateLoader:URLLoader = new URLLoader();
		public var unitTemplateLoader:URLLoader = new URLLoader();
		
		public var improvements:Dictionary = new Dictionary();
		public var buildings:Dictionary = new Dictionary();
		public var itemBase:Dictionary = new Dictionary();
		public var itemRecipes:Dictionary = new Dictionary();
		public var itemStats:Dictionary = new Dictionary();
		public var itemCategories:Dictionary = new Dictionary();
		public var itemTemplates:Dictionary = new Dictionary();
		public var unitTemplates:Dictionary = new Dictionary();
		public var unitRecipes:Dictionary = new Dictionary();

		public function Stats() 
		{

		}
		
		public function init() : void
		{
			improvementLoader.addEventListener(Event.COMPLETE, loadImprovementXML);
			improvementLoader.load(new URLRequest(DomainURL + "improvements.xml"));
			
			buildingLoader.addEventListener(Event.COMPLETE, loadBuildingXML);
			buildingLoader.load(new URLRequest(DomainURL + "building_type.xml"));	
			
			itemLoader.addEventListener(Event.COMPLETE, loadItemXML);
			itemLoader.load(new URLRequest(DomainURL + "item_base.xml"));	
			
			itemStatsLoader.addEventListener(Event.COMPLETE, loadItemStatsXML);
			itemStatsLoader.load(new URLRequest(DomainURL + "item_stats.xml"));
			
			itemCategoryLoader.addEventListener(Event.COMPLETE, loadItemCategoryXML);
			itemCategoryLoader.load(new URLRequest(DomainURL + "item_category.xml"));
			
			itemTemplateLoader.addEventListener(Event.COMPLETE, loadItemTemplateXML);
			itemTemplateLoader.load(new URLRequest(DomainURL + "item_template.xml"));
			
			unitTemplateLoader.addEventListener(Event.COMPLETE, loadUnitTemplateXML);
			unitTemplateLoader.load(new URLRequest(DomainURL + "unit_template.xml"));
		}
		
		public function getAvailableImprovements() : Array
		{
			var available:Array = new Array();
			
			for(var id in improvements)
			{
				var improvementStat:ImprovementStat = ImprovementStat(improvements[id]);
				
				if(improvementStat.level == 1)
				{
					available.push(improvementStat);
				}
			}
			
			return available;
		}
		
		public function getImprovement(id:int) : ImprovementStat
		{
			return ImprovementStat(improvements[id]);
		}
		
		public function getBuilding(id:int) : BuildingStat
		{
			return BuildingStat(buildings[id]);
		} 
		
		public function getItemBase(id:int) : ItemBase
		{			
			return ItemBase(itemBase[id]);
		}
		
		public function getItemStats(id:int) : ItemStats
		{
			return ItemStats(itemStats[id]);
		}
		
		public function getItemCategory(id:int) : ItemCategory
		{
			return ItemCategory(itemCategories[id]);
		}
		
		public function getItemTemplate(id:int) : ItemTemplate
		{
			return ItemTemplate(itemTemplates[id]);
		}
		
		public function getItemRecipe(id:int) : ItemRecipe
		{
			return ItemRecipe(itemRecipes[id]);
		}
		
		public function getUnitRecipe(id:int) : UnitRecipe
		{
			
			for(var key in unitRecipes)
			{
				trace(unitRecipes[key] + " " + unitRecipes[key].typeId) ;
				
			}
			
			trace("Id: " + id);
			
			trace("unitRecipes[id]: " + unitRecipes[id]);			
			
			return UnitRecipe(unitRecipes[id]);
		}
		
		public function getUnitTemplate(id:int) : UnitTemplate
		{
			
			return UnitTemplate(unitTemplates[id]);
		}
		
		public function getItemTemplates() : Array
		{
			var templates:Array = new Array();
			
			for(var id in itemTemplates)
			{
				templates.push(itemTemplates[id]);
			}
			
			return templates;
		}
		
		public function getUnitTemplates() : Array
		{
			var templates:Array = new Array();
			
			for(var id in unitTemplates)
			{
				templates.push(unitTemplates[id]);
			}
			
			return templates;
		}
		
		public function getImprovementItems(improvementType:int) : Array
		{
			var improvementItems:Array = new Array();
			var improvementStat:ImprovementStat = getImprovement(improvementType);
			
			for(var id in itemBase)
			{
				var item:ItemBase = ItemBase(itemBase[id]);
				
				if(item.improvementReq == improvementStat.category)
				{
					improvementItems.push(item);
				}
			}
			
			return improvementItems;
		}
		
		public function getBuildingItems(buildingType:String) : Array
		{
			var buildingItems:Array = new Array();
			
			trace("Stats - buildingType: " + buildingType)
			for(var id in itemBase)
			{
				var item:ItemBase = ItemBase(itemBase[id]);
				
				trace("Stats - item.buildingReq: " + item.buildingReq);
				if(item.buildingReq == buildingType)
				{
					buildingItems.push(item);
				}
			}
			
			return buildingItems;
		}
		
		public function addItemRecipe(recipe:ItemRecipe) : void
		{
			itemRecipes[recipe.typeId] = recipe;
		}
		
		public function addUnitRecipe(recipe:UnitRecipe) : void
		{
			unitRecipes[recipe.typeId] = recipe;
		}
		
		public function isUnknownItemType(type:int) : Boolean
		{
			if(itemBase[type] == null)
			{
				if(itemRecipes[type] == null)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function loadImprovementXML(e:Event) : void
		{
			var xmlData:XML = XML(e.target.data);
			var improvementsList:XMLList = xmlData.row;
			
			for each(var impXML:XML in improvementsList)
			{
				var imp:ImprovementStat = new ImprovementStat();
				
				imp.id = impXML.id;
				imp.category = ImprovementStat.getCategoryId(impXML.imp_type);
				imp.level = impXML.imp_level;
				imp.name = String(impXML.name);
				imp.totalHp = impXML.total_hp;
				imp.populationCap = impXML.population_cap;
				imp.productionCost = impXML.production_cost;
				imp.goldCost = impXML.gold_cost;
				imp.lumberCost = impXML.lumber_cost;
				imp.stoneCost = impXML.stone_cost;
				imp.image48 = impXML.image48;
				
				improvements[imp.id] = imp;
			}
		}
		
		private function loadBuildingXML(e:Event) : void
		{
			var xmlData:XML = XML(e.target.data);
			var buildingsList:XMLList = xmlData.row;
			
			for each(var xml:XML in buildingsList)
			{
				var building:BuildingStat = new BuildingStat();
				
				building.id = xml.id;
				building.buildingGroup = xml.building_group;
				building.name = xml.name;
				building.type = xml.building_type;
				building.level = xml.level;
				building.displayName = xml.display_name;
				building.requires = xml.requires;
				building.hp = xml.hp;
				building.populationCap = xml.population_cap;
				building.productionCost = xml.production_cost;
				building.goldCost = xml.gold_cost;
				building.lumberCost = xml.lumber_cost;
				building.stoneCost = xml.stone_cost;
				building.upkeep = xml.upkeep;
				building.image48 = xml.image48;
				
				trace(building.image48);
				
				buildings[building.id] = building;
			}
		}
		
		private function loadItemXML(e:Event) : void
		{
			trace("Loading Items...");
			var xmlData:XML = XML(e.target.data);
			var itemsList:XMLList = xmlData.row;
			
			for each(var itemXML:XML in itemsList)
			{
				var item:ItemBase = new ItemBase();
				var itemProduces:Array = new Array();
				
				if(itemXML.produces != "None")
				{
					itemProduces = itemXML.produces.split(";");
					trace(itemProduces.toString());
				}
				
				item.type_id = itemXML.type_id;
				item.image48 = itemXML.image48;	
				item.category = itemXML.category;
				item.name = itemXML.name;
				item.productionCost = itemXML.production_cost;
				item.batchAmount = itemXML.batch_amount;
				item.buildingReq = itemXML.building_req;
				item.improvementReq = ImprovementStat.getCategoryId(itemXML.improvement_req);
				item.produces = itemProduces;
				item.materialAmount = itemXML.material_amount;
				item.materialType = itemXML.material_type;
			
				itemBase[item.type_id] = item;
			}
		}
		
		private function loadItemStatsXML(e:Event) : void
		{
			trace("Loading ItemStats");
			var xmlData:XML = XML(e.target.data);
			var itemStatsList:XMLList = xmlData.row;
			
			for each(var itemStatsXML:XML in itemStatsList)
			{
				var item:ItemStats = new ItemStats();
				var effectAmount:Array = new Array();
				var effectType:Array = new Array();
				
				if(String(itemStatsXML.effectType).toLowerCase() != "none")
				{
					effectAmount = itemStatsXML.effect_amount.split(";");
					effectType = itemStatsXML.effect_type.split(";");
				}
				
				item.id = itemStatsXML.id;
				item.name = itemStatsXML.name;
				item.description = itemStatsXML.description;
				item.rarity = itemStatsXML.rarity;
				item.atk_type = itemStatsXML.atk_type;
				item.atk = itemStatsXML.atk;
				item.def = itemStatsXML.def;
				item.range = itemStatsXML.range;
				item.speed = itemStatsXML.speed;
				item.acc = itemStatsXML.acc;
				item.eva = itemStatsXML.eva;
				item.weight = itemStatsXML.weight;
				//item.effect_amount = itemStatsXML.effect_amount;
				//item.effect_type = itemStatsXML.effect_type;
				item.food = itemStatsXML.food;
				item.build = itemStatsXML.build;
				item.value = itemStatsXML.value;
				
				itemStats[item.id] = item;
			}
		}
		
		private function loadItemCategoryXML(e:Event) : void		
		{
			var xmlData:XML = XML(e.target.data);
			var itemCategoryList:XMLList = xmlData.row;
			
			for each(var itemXML:XML in itemCategoryList)
			{			
				var itemCategory:ItemCategory = new ItemCategory();
				var itemContains:Array = new Array();
			
				if(itemXML.contains != "None")
				{
					itemContains = itemXML.contains.split(";");
				}
			
				itemCategory.id = itemXML.item_category_id;
				itemCategory.name = itemXML.name;
				itemCategory.contains = itemContains;
				
				itemCategories[itemCategory.id] = itemCategory;
			}
		}
		
		private function loadItemTemplateXML(e:Event) : void
		{
			var xmlData:XML = XML(e.target.data);
			var itemTemplateList:XMLList = xmlData.row;
			
			for each(var xml:XML in itemTemplateList)
			{			
				var itemTemplate:ItemTemplate = new ItemTemplate();
				var materialType:Array = new Array();
				var materialAmount:Array = new Array();
			
				if(xml.material_type != "None")
				{
					materialType = xml.material_type.split(";");
					materialAmount = xml.material_amount.split(";");
				}
				
				itemTemplate.id = xml.id;
				itemTemplate.itemCategory = xml.item_category;
				itemTemplate.name = xml.name;
				itemTemplate.batchAmount = xml.batch_amount;
				itemTemplate.productionCost = xml.production_cost;
				itemTemplate.buildingReq = xml.building_req;
				itemTemplate.buildingLevelReq = xml.building_level_req;
				itemTemplate.materialCategory = materialType;
				itemTemplate.materialAmount = materialAmount;
				
				itemTemplates[itemTemplate.id] = itemTemplate;
			}
		}
		
		
		private function loadUnitTemplateXML(e:Event) : void
		{
			var xmlData:XML = XML(e.target.data);
			var unitTemplateList:XMLList = xmlData.row;
			
			for each(var xml:XML in unitTemplateList)
			{			
				var unitTemplate:UnitTemplate = new UnitTemplate();	
				var materialCategory:Array = new Array();
				var materialAmount:Array = new Array();
			
				if(xml.material_type != "None")
				{
					materialCategory = xml.material_category.split(";");
					materialAmount = xml.material_amount.split(";");
				}
				
				unitTemplate.id = xml.id;
				unitTemplate.name = xml.name;
				unitTemplate.level = xml.level;
				unitTemplate.type = xml.type;
				unitTemplate.buildingReq = xml.buildingReq;
				unitTemplate.hp = xml.hp;
				unitTemplate.atk = xml.atk;
				unitTemplate.def = xml.def;
				unitTemplate.range = xml.range;
				unitTemplate.speed = xml.speed;
				unitTemplate.acc = xml.acc;
				unitTemplate.eva = xml.eva;
				unitTemplate.effectAmount = xml.effect_amount;
				unitTemplate.effectType = xml.effect_type;
				unitTemplate.productionCost = xml.production_cost;
				unitTemplate.goldCost = xml.gold_cost;
				unitTemplate.materialAmount = materialAmount;
				unitTemplate.materialCategory = materialCategory;
				unitTemplate.upkeep = xml.upkeep;
				unitTemplate.food = xml.food;
				unitTemplate.capacity = xml.capacity;
				unitTemplate.def_size = xml.def_size;
				unitTemplate.min_size = xml.min_size;
				unitTemplate.max_size = xml.max_size;
				unitTemplate.movement = xml.movement;
				unitTemplate.value = xml.value;
				
				unitTemplates[unitTemplate.id] = unitTemplate;
				
			}
		}

	}
	
}