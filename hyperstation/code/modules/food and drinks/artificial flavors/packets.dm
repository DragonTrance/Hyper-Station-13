/*					*
 *	Basic Sweetener	*
 *					*/
//A very strong sweetener. Used as a de-greaser and a paint stripper, this doesn't exactly bode well to the human body.
//Causes headaches, liver/kidney impairment, problems with eyesight, and hypoglycemia
/datum/reagent/taste/basic_sweetener
	name = "Acesulfame Potassium"
	desc = "A basic artificial sweetener. Too much of this can hinder metabolism and damage the liver."
	taste_desc = "artificial sweetness"
	color = "#ff9"
	pH = 12
	take_over_taste = 20	//According to a few sources, this chemical is 200 times sweeter than sucrose, but its still not very sweet
	overdose_min = 5
	overdose_lower = 25
	overdose_low = 30
	overdose_med = 100

/datum/reagent/taste/basic_sweetener/on_mob_end_metabolize(mob/living/carbon/human/L)
	if(..())
		to_chat(L, "<span class='italic' style='color:[TASTE_COLOR_APPEASE]'>You feel the sweetness against your tongue dissolve, and a bitter aftertaste takes place.</span>")

/datum/reagent/taste/basic_sweetener/taste_overdose_min(mob/living/carbon/human/L)
	if(!..())
		return
	overdose_exponential = 0
	if(current_cycle == 1)
		to_chat(L, "<span class='warning'>The sweetness is unbearable!</span>")
		SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "[type]", /datum/mood_event/unbearable_sweetness)
	if(!(current_cycle % 10))
		overdose_exponential = current_cycle/10
		to_chat(L, "<span class='warning'>You taste an unbearable sweetness!</span>")

/datum/reagent/taste/basic_sweetener/taste_overdose_lower(mob/living/carbon/human/L)
	if(!(current_cycle % 8))
		to_chat(L, "<span class='warning'>Your head hurts...</span>")
	L.reagents.add_reagent(/datum/reagent/consumable/sugar, REAGENTS_METABOLISM / 2)

/datum/reagent/taste/basic_sweetener/taste_overdose_low(mob/living/carbon/human/L)
	if(..())
		L.eye_blurry += 2
	if(!(current_cycle % 8))
		if(!L.getorganslot(ORGAN_SLOT_LIVER))
			L.adjustToxLoss(5)
		else
			L.adjustOrganLoss(ORGAN_SLOT_LIVER, 8)

/datum/reagent/taste/basic_sweetener/taste_overdose_med(mob/living/carbon/human/L)
	to_chat(L, "<span class='userdanger'>You go into hyperglycaemic shock! Lay off the twinkies!</span>")
	L.AdjustSleeping(600, FALSE)
	L.reagents.remove_reagent(src, round(volume/1.5), FALSE)
	L.reagents.add_reagent(/datum/reagent/consumable/sugar, REAGENTS_METABOLISM * 10)

/*				*
 *	Advantame	*
 *				*/

/datum/reagent/taste/advantame
	name = "Advantame"
	desc = "One of the strongest artificial sweeteners, over 20,000 times stronger than sucrose."
	color = "#fff"
