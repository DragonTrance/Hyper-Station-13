/datum/species/proc/get_icon_from_worn(obj/item/I, layer)
	if(!istype(I))
		throw EXCEPTION("Attempted to get a species icon for an item when the item doesn't exist.")
		return
	if(!istype(I, /obj/item))
		throw EXCEPTION("Attempted to get a species icon for an item when the variable isn't a subtype of /obj/item.")
		return
	
	if(!LAZYLEN(worn_icons))
		return
	
	if(worn_icons_use_type)
		var/icon_path = worn_icons["[I.type]"]
		if(isnum(icon_path))
			return 'icons/null.dmi'
		else if(icon_path)
			return icon_path
		else if(worn_icons_is_needed)
			return 'icons/null.dmi'
	else
		var/icon_path = worn_icons["[layer]"]
		if(isnum(icon_path))
			return 'icons/null.dmi'
		else if(icon_path)
			return icon_path
		else if(worn_icons_is_needed)
			return 'icons/null.dmi'
