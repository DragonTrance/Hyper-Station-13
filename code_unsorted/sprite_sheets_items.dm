//This is a bit hard to read, but basically returns our icon path first before the species
/obj/item/proc/get_icon_for_species(datum/species/pref_species, species_id, layer)
	if(!species_id)
		return
	if(!LAZYLEN(species_worn_icons))
		return

	if(!species_worn_icons[species_id])
		if(istype(pref_species))
			return pref_species.get_icon_from_worn(src, layer)
	else
		var/icon_path = species_worn_icons[species_id]
		if(isnum(icon_path))
			return 'icons/null.dmi'
		else
			return icon_path
