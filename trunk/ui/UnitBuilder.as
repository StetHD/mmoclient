﻿package ui {		import flash.display.MovieClip;	import fl.text.TLFTextField;	import flashx.textLayout.formats.TextLayoutFormat;	import flash.events.MouseEvent;	import flashx.textLayout.elements.TextFlow;	import flash.display.DisplayObject;	import flash.display.Bitmap;	import flash.text.TextField;	import game.Item;	import ui.events.UnitBuilderDragDropEvent;	import ui.events.CityUIEvents;		import game.Game;	import stats.UnitTemplate;	import ui.events.GameEvents;		public class UnitBuilder extends MovieClip 	{		public static var MAX_PER_PAGE:int = 25;				public var unitBuilderStats:UnitBuilderStats;				public var unitName:TextField;		public var gearPanel:MovieClip;		public var statsText:TLFTextField;		public var gearText:TLFTextField;		public var abilitiesText:TLFTextField;				public var typeDropDown:WideDropDown;		public var typeDropDownList:MovieClip;				public var saveButton:ContractButton;		public var cancelButton:ContractButton;		public var closeButton:CloseButton;				public var pagination:Pagination;				private var selectedTemplate:UnitTemplate;				private var typeList:Array = new Array();		private var gearList:Array = new Array();				private var dropDownBgHeight:int;		private var currentPage:int;		private var totalPages:int;						public function UnitBuilder()		{			statsText.addEventListener(MouseEvent.CLICK, statsClick);			gearText.addEventListener(MouseEvent.CLICK, gearClick);			typeDropDown.addEventListener(MouseEvent.CLICK, typeDropDownClick);									saveButton.addEventListener(MouseEvent.CLICK, saveButtonClick);			cancelButton.addEventListener(MouseEvent.CLICK, closeButtonClick);			closeButton.addEventListener(MouseEvent.CLICK, closeButtonClick);									pagination.leftArrow.addEventListener(MouseEvent.CLICK, leftArrowClick)			pagination.rightArrow.addEventListener(MouseEvent.CLICK, rightArrowClick);									saveButton.buttonName.text = "Save";			cancelButton.buttonName.text = "Cancel";						typeDropDown.selectedName.text = "Selected Unit Template";						addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);				addEventListener(MouseEvent.MOUSE_UP, mouseUp);											UIEventDispatcher.INSTANCE.addEventListener(CityUIEvents.UnitBuilderDragDropEvent, itemDropEvent);			UIEventDispatcher.INSTANCE.addEventListener(GameEvents.SuccessAddUnitRecipe, successAddUnitRecipe);		}				public function showPanel() : void		{			this.parent.setChildIndex(this, this.parent.numChildren - 1);							this.visible = true;						pagination.visible = false;			typeDropDownList.visible = false;						currentPage = 0;		}						private function typeDropDownClick(e:MouseEvent) : void		{				typeDropDownList.visible = true;			pagination.visible = true;						setTotalPages();			setCurrentPage();			setDropDownList();		}					private function setDropDownList() : void		{			var yPos:int = 1;			var max:int = ((currentPage + 1) * MAX_PER_PAGE);					var unitTemplates:Array = Stats.INSTANCE.getUnitTemplates();						removeTypes();						if(max >= unitTemplates.length)			{				max = unitTemplates.length;			}								for(var i:int = currentPage * MAX_PER_PAGE; i < max; i++)			{				var unitTemplate:UnitTemplate = UnitTemplate(unitTemplates[i]);				var unitListEntry:UnitBuilderListEntry = new UnitBuilderListEntry();								unitListEntry.unitText = new TLFTextField();				unitListEntry.unitTemplate = unitTemplate;								unitListEntry.unitText.text = unitTemplate.name;				unitListEntry.unitText.width = 180;				unitListEntry.unitText.selectable = false;				unitListEntry.unitText.mouseChildren = false;					 			unitListEntry.unitText.x = 0;				unitListEntry.unitText.y = yPos * 12;												unitListEntry.addChild(unitListEntry.unitText);				unitListEntry.addEventListener(MouseEvent.CLICK, unitTemplateClick);								typeDropDownList.addChild(unitListEntry);				typeList.push(unitListEntry);							    var myFormat:TextLayoutFormat = new TextLayoutFormat();				myFormat.textIndent = 8;			    myFormat.color = 0xFFFFFF;				myFormat.fontFamily = "Verdana";				myFormat.fontSize = 10;				 				var myTextFlow:TextFlow = unitListEntry.unitText.textFlow;				myTextFlow.hostFormat = myFormat;				myTextFlow.flowComposer.updateAllControllers();											yPos++;			}						}				private function unitTemplateClick(e:MouseEvent) : void		{			var listEntry:UnitBuilderListEntry = UnitBuilderListEntry(e.target.parent);			trace("listEntry: " + listEntry.unitTemplate.id);						typeDropDownList.visible = false;			pagination.visible = false;						selectedTemplate = listEntry.unitTemplate;			setUnitTemplateInfo();			setStats();			setGear();		}						private function setUnitTemplateInfo() : void		{			typeDropDown.selectedName.text = selectedTemplate.name;		}						private function setStats() : void		{			if(selectedTemplate != null)			{				var unitTemplate:UnitTemplate = Stats.INSTANCE.getUnitTemplate(selectedTemplate.id);								unitBuilderStats.atk.text = unitTemplate.atk.toString();				unitBuilderStats.def.text = unitTemplate.def.toString();				unitBuilderStats.range.text = unitTemplate.range.toString();				unitBuilderStats.acc.text = unitTemplate.acc.toString();				unitBuilderStats.eva.text = unitTemplate.eva.toString();				unitBuilderStats.speed.text = unitTemplate.speed.toString();				unitBuilderStats.movement.text = unitTemplate.movement.toString();			}		}						private function statsClick(e:MouseEvent) : void		{			unitBuilderStats.visible = true;		}				private function gearClick(e:MouseEvent) : void		{			unitBuilderStats.visible = false;			setGear();		}				private function setGear() : void		{			removeSlots();						var gearNames:Array;						switch(selectedTemplate.type)			{				case "Melee":				case "Range":				case "Magic":					gearNames = getStandardSlotNames();					break;				case "Rowing Ship":				case "Sailing Ship":				case "Steam Ship":				case "Skysail Airship":				case "Lifter Airship":					gearNames = getShipSlotNames();					break;				default:					gearNames = new Array();			}						for(var i:int = 0; i < selectedTemplate.level; i++)			{				var gearEntry:ItemBuilderMaterialEntry = new ItemBuilderMaterialEntry();								gearEntry.itemName.text = gearNames[i];				gearEntry.quantity.text = "";				gearEntry.materialStatus.text = "";				gearEntry.filled = false;								gearEntry.x = 2;				gearEntry.y = 3 + (i * (gearEntry.height + 3));								gearEntry.mouseChildren = false;								gearPanel.addChild(gearEntry);				gearList.push(gearEntry);							}				}				private function itemDropEvent(e:UnitBuilderDragDropEvent) : void		{			var item:Item = e.item;			var gearEntry:ItemBuilderMaterialEntry = checkDropTarget(e.itemDropTarget);						trace(gearEntry);			if(gearEntry != null)			{				setFilledGear(gearEntry, item);			}		}				private function checkDropTarget(itemDropTarget:DisplayObject) : ItemBuilderMaterialEntry		{			for(var i:int = 0; i < gearList.length; i++)			{				var gearEntry:ItemBuilderMaterialEntry = ItemBuilderMaterialEntry(gearList[i]);								if(gearEntry == itemDropTarget.parent && gearEntry.contains(itemDropTarget))				{					return gearEntry;				}			}						return null;		}						private function setFilledGear(gearEntry:ItemBuilderMaterialEntry, item:Item) : void		{			gearEntry.materialStatus.text = item.getName();			gearEntry.quantity.text = item.getCategory();			gearEntry.filled = true;			gearEntry.filledItemType = item.type;						var itemImage:Bitmap = new Bitmap(item.getImage());			itemImage.x = 0;			itemImage.y = 0;						gearEntry.addChild(itemImage);		}						private function getStandardSlotNames() : Array		{			var slotNames:Array = new Array();						slotNames.push("Main Hand");			slotNames.push("Off Hand");			slotNames.push("Armor");			slotNames.push("Auxiliary 1");			slotNames.push("Auxiliary 2");						return slotNames;		}				private function getShipSlotNames() : Array		{			var slotNames:Array = new Array();						slotNames.push("Engine");			slotNames.push("Hold/Gear");			slotNames.push("Hold/Gear");			slotNames.push("Hold/Gear");			slotNames.push("Hold/Gear");						return slotNames;					}				private function removeTypes() : void		{			for(var i:int = 0; i < typeList.length; i++)			{				if(typeDropDownList.contains(typeList[i]))				{					typeDropDownList.removeChild(typeList[i]);				} 			}						typeList = new Array();		}								private function removeSlots() : void		{			for(var i:int = 0; i < gearList.length; i++)			{				if(gearPanel.contains(gearList[i]))				{					gearPanel.removeChild(gearList[i]);				}			}						gearList = new Array();		}						private function getGearList() : Array		{			var gearTypes:Array = new Array();						for(var i:int = 0; i < gearList.length; i++)			{				var gearEntry:ItemBuilderMaterialEntry = ItemBuilderMaterialEntry(gearList[i]);								gearTypes.push(gearEntry.filledItemType);			}						return gearTypes;		}				private function saveButtonClick(e:MouseEvent) : void		{						trace("GearList: " + getGearList());						var parameters:Object = {templateId: selectedTemplate.id,									 playerId: Game.INSTANCE.player.id,									 unitName: unitName.text,									 defaultSize: 100,									 gear: getGearList()};						var pEvent:ParamEvent = new ParamEvent(Game.addUnitRecipeEvent);			pEvent.params = parameters;							Game.INSTANCE.dispatchEvent(pEvent);					}				private function setTotalPages() : void		{			var unitTemplates:Array = Stats.INSTANCE.getUnitTemplates();			totalPages = unitTemplates.length / MAX_PER_PAGE;						if((unitTemplates.length % MAX_PER_PAGE) != 0);			{				totalPages++;			}			pagination.totalPages.text = totalPages.toString();		}				private function setCurrentPage() : void		{			var currentPageText:int = currentPage + 1;			pagination.currentPage.text = currentPageText.toString();		}						private function leftArrowClick(e:MouseEvent) : void		{			if(currentPage > 0)			{				currentPage--;				setCurrentPage();				setDropDownList();			}		}				private function rightArrowClick(e:MouseEvent) : void		{			if(currentPage < (totalPages - 1))			{				currentPage++;				setCurrentPage();				setDropDownList();			}		}						private function successAddUnitRecipe(e:ParamEvent) : void		{			this.visible = false;		}				private function closeButtonClick(e:MouseEvent) : void		{			this.visible = false;		}							private function mouseDown(e:MouseEvent) : void		{				e.stopImmediatePropagation();						this.parent.setChildIndex(this, this.parent.numChildren - 1);			startDrag();					}						private function mouseUp(e:MouseEvent) : void		{					e.stopImmediatePropagation();			stopDrag();		}					}	}