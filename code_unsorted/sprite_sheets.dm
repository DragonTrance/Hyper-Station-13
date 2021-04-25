//Suggestion: hyperstation module folder
//affected files:
//code\__DEFINES\inventory.dm
//code\modules\mob\living\carbon\human\update_icons.dm
//icons\null.dmi
//untested and not compiled yet. dont expect things to work immediately

//Differentiating sprites for worn items depending on species.
//A few servers actually have this, though for this server we do our own things
//Coded by DragonTrance, aka "Breaks-The-Code"

//In this file: Explainations for item icons on different species.
//Scroll down more for proc explainations

//***********************//
//     SPECIES ICONS     //
//***********************//
/datum/species
	var/worn_icons_is_needed = FALSE
	var/list/worn_icons = list()
	var/worn_icons_use_type = TRUE

//Species use two vars: worn_icons_use_types, and worn_icons as a list.
//worn_icons_use_types is used for coding reasons, as if this is TRUE without paths, it will lead to runtimes
//worn_icons is the list to change how items will appear on a species. Syntax is important, warnings will show if there is improper syntax
//
//worn_icons_is_needed, when true, will make every icon use a null state if the current species cannot be found in worn_icons.
//This is so things don't look like shit when worn
////////////
//EXAMPLES//
////////////
/*
--
Paths:
worn_icons_use_types = TRUE		//Needs to be true. If false, nothing will happen per se, though there will be unnecessary CPU usage, especially if the list is large
worn_icons = list(
	"/obj/item/clothing/head/hardhat" = 'icon/mob/some_path.dmi',			//All subtypes of this will be affected
	"/obj/item/clothing/head/hardhat/weldhat" = 'icon/mob/some_path.dmi'	//All subtypes of this will be affected, overrides above. Needs to be second
	"/obj/item/clothing/head/hardhat/weldhat/orange" = 0					//Subtypes of this will show no icon whatsoever when worn
)
--
Equip Location:
worn_icons_use_types = FALSE	//Needs to be false. If true, runtimes will happen
worn_icons = list(
	"[SLOT_HEAD]" = 'icon/mob/some_path.dmi',	//Every head item will use this path. This includes anything that will be equipped onto heads, not just subtypes
	"[SLOT_NECK]" = 'icon/mob/some_path.dmi',	//Every neck item subtype will use this path
	"[SLOT_WEAR_NECK]" = 0,						//Any item in the mask slot will show no icon whatsoever
	"handcuffs" = 'icon/mob/some_path.dmi',		//Handcuffs
	"legcuffs" = 'icon/mob/some_path.dmi',		//Legcuffs
	"l_hand" = 'icon/mob/some_path.dmi',		//Left hand
	"r_hand" = 'icon/mob/some_path.dmi'			//Right hand
)
--
*/

//***********************//
//     ITEM-SPECIFIC     //
//***********************//
/obj/item/
	var/list/species_worn_icons = list()
	var/list/required_worn = list()

//species_worn_icons is the var for all items, whether or not they can be worn. This is in the case you use worn_icons_use_types for species,
//but still want a specific item to use a different path. The species ID is required, not its name
//
//required_worn will override species' worn_icons_is_needed if FALSE, shoes, helmets, and hand icons use this
//It's a list and works similar to species_worn_icons, though you don't need to define values in the list -- you can just keep it like list("lizard")
//
//species_worn_icons Example:
/*
species_worn_icon = list(
	"abductor" = 'icon/mob/some_path.dmi',
	"mush" = 'icon/mob/some_path.dmi',			//rest in peace, mushroom man
	"lizard" = 'icon/mob/some_path.dmi',		//Lizard people
	"jelly" = 'icon/mob/some_path.dmi',			//Xenobio Jelly People
	"slimeperson" = 'icon/mob/some_path.dmi'	//Citadel slime people
)
*/

//***********************//
//       MUTATIONS       //
//***********************//
//I had an idea to apply vars for mutation appearances, but found out that mutations have a lack of modularization with
//their appearances, especially for this case. Instead, they are handled in mutations themselves.
//A good example is in telekinesis, code\datums\mutations\telekinesis.dm



//***********//
//   PROCS   //
//***********//
//TODO: Put stuff here. If there isn't anything explained here after a PR, tell me to update this
