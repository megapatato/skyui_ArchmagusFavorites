import skyui.defines.Actor;
import skyui.defines.Form;

import skyui.components.list.BasicList;
import skyui.components.list.IListProcessor;
import skyui.util.Hash;


class FilterDataExtender implements IListProcessor
{
  /* CONSTANTS */
  
	public static var FILTERFLAG_ALL					= 0x1FF;	// 511	// Sum of all filter flags
	public static var FILTERFLAG_DEFAULT				= 0x001;	// 1	// These match filterFlag in Component Definitions
	public static var FILTERFLAG_GEAR					= 0x002;	// 2	// used in the buttons of FavoritesMenu.fla
	public static var FILTERFLAG_AID					= 0x004;	// 4	// Also, in the Component Parameters of the btn objects in the FavoritesMenu movie clip
	public static var FILTERFLAG_SCHOOL_ALTERATION 		= 0x008;	// 8
	public static var FILTERFLAG_SCHOOL_CONJURATION 	= 0x010;	// 16
	public static var FILTERFLAG_SCHOOL_DESTRUCTION 	= 0x020;	// 32
	public static var FILTERFLAG_SCHOOL_ILLUSION 		= 0x040;	// 64
	public static var FILTERFLAG_SCHOOL_RESTORATION 	= 0x080;	// 128
	public static var FILTERFLAG_SHOUT					= 0x100;	// 256

	public static var FILTERFLAG_GROUP_ADD				= 0x200;	// 512
	public static var FILTERFLAG_GROUP_0				= 0x400;	// 1024
	// Group N+1 = (GROUP_N << 1) | GROUP_ADD
	
	
  /* PRIVATE VARIABLES */
  
  /* PROPERTIES */
	
  /* INITIALIZATION */
	
	public function FilterDataExtender()
	{
	}
	
	
  /* PUBLIC FUNCTIONS */
	
  	// @override IListProcessor
	public function processList(a_list: BasicList): Void
	{
		var entryList = a_list.entryList;
		
		for (var i = 0; i < entryList.length; i++) {
			var e = entryList[i];
			if (e.skyui_itemDataProcessed)
				continue;
				
			e.skyui_itemDataProcessed = true;
		
			processEntry(e);
		}
	}

  /* PRIVATE FUNCTIONS */
  
	private function processEntry(a_entryObject: Object): Void
	{
		// ItemID
		a_entryObject.itemId &= 0xFFFFFFFF; // better safe than sorry
	
		var formType = a_entryObject.formType;

		switch(formType) {
			case Form.TYPE_ARMOR:
			case Form.TYPE_AMMO:
			case Form.TYPE_WEAPON:
			case Form.TYPE_LIGHT:
				a_entryObject.filterFlag = FILTERFLAG_GEAR;
				break;
				
			case Form.TYPE_INGREDIENT:
			case Form.TYPE_POTION:
				a_entryObject.filterFlag = FILTERFLAG_AID;
				break;
				
			case Form.TYPE_SPELL:
			case Form.TYPE_SCROLLITEM:
				switch(a_entryObject.school) {
					case Actor.AV_ALTERATION:
						a_entryObject.filterFlag = FILTERFLAG_SCHOOL_ALTERATION;
						break;

					case Actor.AV_CONJURATION:
						a_entryObject.filterFlag = FILTERFLAG_SCHOOL_CONJURATION;
						break;

					case Actor.AV_DESTRUCTION:
						a_entryObject.filterFlag = FILTERFLAG_SCHOOL_DESTRUCTION;
						break;

					case Actor.AV_ILLUSION:
						a_entryObject.filterFlag = FILTERFLAG_SCHOOL_ILLUSION;
						break;

					case Actor.AV_RESTORATION:
						a_entryObject.filterFlag = FILTERFLAG_SCHOOL_RESTORATION;
						break;
					
					default:
						a_entryObject.filterFlag = FILTERFLAG_DEFAULT;
						break;
				}
				break;

			case Form.TYPE_SHOUT:
				a_entryObject.filterFlag = FILTERFLAG_SHOUT;
				break;
			
			case Form.TYPE_BOOK:
			case Form.TYPE_EFFECTSETTING:
			default:
				// This is a default flag to make sure ALL includes everything
				a_entryObject.filterFlag = FILTERFLAG_DEFAULT;
				break;
		}
	}
}