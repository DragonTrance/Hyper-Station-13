/datum/reagent/taste
	name = "artificial flavor"
	desc = "It seems to be a flavor for something... but it's not really known to what."
	taste_description = "something indescribeable"
	taste_mult = 15
	glass_name = "glass of flavor-paste"
	glass_desc = "It looks almost solid... Or is that powder? No, it's definitely a liquid."
	color = "#d55"
	metabolization_rate = REAGENTS_METABOLISM / 10
	value = 0.1
	var/take_over_taste = 10		//If non-zero, then at this many units will we be the only taste
	var/overdose_exponential = 0	//How fast the reagent will leave the body when overdosing
	var/taste_overdosing = 0		//Bitfield
	var/overdose_min = -1
	var/overdose_lower = -1
	var/overdose_low = -1
	var/overdose_medium = -1
	var/overdose_high = -1
	var/overdose_higher = -1
	var/overdose_max = -1			//Custom overdose values, because artificial flavoring can do tons of different things

/datum/reagent/taste/on_mob_life(mob/living/carbon/human/L)	//ghetto but it works. no warning messages because you shouldn't really put more than a drop in a glass
	..()
	if(!istype(L, /mob/living/carbon/human))
		return
	taste_overdosing = 0
	if(overdosing_min >= 0 && volume > overdosing_min)
		taste_overdosing |= OD_MIN
		taste_overdose_min(L)
	if(overdosing_lower >= 0 && volume > overdosing_lower)
    	taste_overdosing |= OD_LOWR
		taste_overdose_lower(L)
	if(overdosing_low >= 0 && volume > overdosing_low)
		taste_overdosing |= OD_LOW
		taste_overdose_low(L)
	if(overdosing_medium >= 0 && volume > overdosing_medium)
		taste_overdosing |= OD_MED
		taste_overdose_med(L)
	if(overdosing_high >= 0 && volume > overdosing_high)
		taste_overdosing |= OD_HI
		taste_overdose_high(L)
	if(overdosing_higher >= 0 && volume > overdosing_higher)
		taste_overdosing |= OD_HIR
		taste_overdose_higher(L)
	if(overdosing_max >= 0 && volume > overdosing_max)
		taste_overdosing |= OD_MAX
		taste_overdose_max(L)

	if(taste_overdosing && holder)
		holder.remove_reagent(type, (metabolization_rate * M.metabolism_efficiency) * overdose_exponential) //By default it slowly disappears.
	
	return L.getorganslot(ORGAN_SLOT_TONGUE)

/datum/reagent/taste/on_mob_metabolize(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/on_mob_end_metabolize(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_min(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_lower(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_low(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_med(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_high(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_higher(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)
/datum/reagent/taste/proc/taste_overdose_max(mob/living/carbon/human/L)
	return L.getorganslot(ORGAN_SLOT_TONGUE)