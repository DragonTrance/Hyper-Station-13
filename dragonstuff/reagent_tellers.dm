/obj/item/teller
	name = "Teller"
	desc = "yes"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	var/list/cached_catched = list()

/obj/item/teller/attack_self(mob/user)
	to_chat(user, "Create this reagent: [_catch()]")

/obj/item/teller/proc/_catch()
	return "Hehe broken"

/obj/item/teller/bartender
	name = "\improper Bartending Teacher"
	desc = "Hone your bartending skills by trying to recall how to make X object!"
	var/datum/chemical_reaction/got_told
	cached_catched = list(
		/datum/chemical_reaction/goldschlager, /datum/chemical_reaction/patron, /datum/chemical_reaction/bilk,
		/datum/chemical_reaction/icetea, /datum/chemical_reaction/icecoffee, /datum/chemical_reaction/nuka_cola,
		/datum/chemical_reaction/moonshine, /datum/chemical_reaction/wine, /datum/chemical_reaction/spacebeer,
		/datum/chemical_reaction/vodka, /datum/chemical_reaction/kahlua, /datum/chemical_reaction/gin_tonic,
		/datum/chemical_reaction/rum_coke, /datum/chemical_reaction/cuba_libre, /datum/chemical_reaction/martini,
		/datum/chemical_reaction/vodkamartini, /datum/chemical_reaction/white_russian, /datum/chemical_reaction/whiskey_cola,
		/datum/chemical_reaction/screwdriver, /datum/chemical_reaction/bloody_mary, /datum/chemical_reaction/gargle_blaster,
		/datum/chemical_reaction/brave_bull, /datum/chemical_reaction/tequila_sunrise, /datum/chemical_reaction/toxins_special,
		/datum/chemical_reaction/beepsky_smash, /datum/chemical_reaction/doctor_delight, /datum/chemical_reaction/irish_cream,
		/datum/chemical_reaction/manly_dorf, /datum/chemical_reaction/greenbeer, /datum/chemical_reaction/hooch,
		/datum/chemical_reaction/irish_coffee, /datum/chemical_reaction/b52, /datum/chemical_reaction/atomicbomb,
		/datum/chemical_reaction/margarita, /datum/chemical_reaction/longislandicedtea, /datum/chemical_reaction/threemileisland,
		/datum/chemical_reaction/whiskeysoda, /datum/chemical_reaction/black_russian, /datum/chemical_reaction/manhattan,
		/datum/chemical_reaction/manhattan_proj, /datum/chemical_reaction/vodka_tonic, /datum/chemical_reaction/gin_fizz,
		/datum/chemical_reaction/bahama_mama, /datum/chemical_reaction/singulo, /datum/chemical_reaction/alliescocktail,
		/datum/chemical_reaction/demonsblood, /datum/chemical_reaction/booger, /datum/chemical_reaction/antifreeze,
		/datum/chemical_reaction/barefoot, /datum/chemical_reaction/painkiller, /datum/chemical_reaction/pina_colada,
		/datum/chemical_reaction/sbiten, /datum/chemical_reaction/red_mead, /datum/chemical_reaction/mead,
		/datum/chemical_reaction/iced_beer, /datum/chemical_reaction/grog, /datum/chemical_reaction/soy_latte,
		/datum/chemical_reaction/cafe_latte, /datum/chemical_reaction/acidspit, /datum/chemical_reaction/amasec,
		/datum/chemical_reaction/changelingsting, /datum/chemical_reaction/aloe, /datum/chemical_reaction/andalusia,
		/datum/chemical_reaction/neurotoxin, /datum/chemical_reaction/snowwhite, /datum/chemical_reaction/irishcarbomb,
		/datum/chemical_reaction/syndicatebomb, /datum/chemical_reaction/erikasurprise, /datum/chemical_reaction/devilskiss,
		/datum/chemical_reaction/hippiesdelight, /datum/chemical_reaction/bananahonk, /datum/chemical_reaction/silencer,
		/datum/chemical_reaction/driestmartini, /datum/chemical_reaction/thirteenloko, /datum/chemical_reaction/chocolatepudding,
		/datum/chemical_reaction/vanillapudding, /datum/chemical_reaction/cherryshake, /datum/chemical_reaction/bluecherryshake,
		/datum/chemical_reaction/drunkenblumpkin, /datum/chemical_reaction/pumpkin_latte, /datum/chemical_reaction/gibbfloats,
		/datum/chemical_reaction/triple_citrus, /datum/chemical_reaction/grape_soda, /datum/chemical_reaction/grappa,
		/datum/chemical_reaction/whiskey_sour, /datum/chemical_reaction/fetching_fizz, /datum/chemical_reaction/hearty_punch,
		/datum/chemical_reaction/bacchus_blessing, /datum/chemical_reaction/lemonade, /datum/chemical_reaction/arnold_palmer,
		/datum/chemical_reaction/chocolate_milk, /datum/chemical_reaction/eggnog, /datum/chemical_reaction/narsour,
		/datum/chemical_reaction/quadruplesec, /datum/chemical_reaction/grasshopper, /datum/chemical_reaction/stinger,
		/datum/chemical_reaction/quintuplesec, /datum/chemical_reaction/bastion_bourbon, /datum/chemical_reaction/squirt_cider,
		/datum/chemical_reaction/fringe_weaver, /datum/chemical_reaction/sugar_rush, /datum/chemical_reaction/crevice_spike,
		/datum/chemical_reaction/sake, /datum/chemical_reaction/peppermint_patty, /datum/chemical_reaction/alexander,
		/datum/chemical_reaction/sidecar, /datum/chemical_reaction/between_the_sheets, /datum/chemical_reaction/kamikaze,
		/datum/chemical_reaction/mojito, /datum/chemical_reaction/fernet_cola, /datum/chemical_reaction/fanciulli,
		/datum/chemical_reaction/branca_menta, /datum/chemical_reaction/pwrgame, /datum/chemical_reaction/pinkmilk,
		/datum/chemical_reaction/pinktea, /datum/chemical_reaction/blank_paper, /datum/chemical_reaction/wizz_fizz,
		/datum/chemical_reaction/bug_spray, /datum/chemical_reaction/jack_rose, /datum/chemical_reaction/turbo,
		/datum/chemical_reaction/old_timer, /datum/chemical_reaction/rubberneck, /datum/chemical_reaction/duplex,
		/datum/chemical_reaction/trappist, /datum/chemical_reaction/cream_soda, /datum/chemical_reaction/blazaam,
		/datum/chemical_reaction/planet_cracker, /datum/chemical_reaction/red_queen, /datum/chemical_reaction/gunfire,
		/datum/chemical_reaction/hellfire, /datum/chemical_reaction/sins_delight, /datum/chemical_reaction/strawberry_daiquiri,
		/datum/chemical_reaction/miami_vice, /datum/chemical_reaction/malibu_sunset, /datum/chemical_reaction/liz_fizz,
		/datum/chemical_reaction/hotlime_miami, /datum/chemical_reaction/commander_and_chief, /datum/chemical_reaction/wockyslush,
		/datum/chemical_reaction/cum_in_a_hot_tub, /datum/chemical_reaction/cum_in_a_hot_tub/semen
	)

/obj/item/teller/bartender/attack_self(mob/user)
	if(got_told)
		var/datum/reagent/id = got_told.id
		. += "This is how to create [initial(id.name)]:"
		for(var/A in got_told.required_reagents)
			var/datum/reagent/R = A
			. += "\n* [got_told.required_reagents[R]]u [initial(R.name)]"
		for(var/A in got_told.required_catalysts)
			var/datum/reagent/R = A
			. += "\n* ([got_told.required_catalysts[R]]u [initial(R.name)])"
		if(got_told.required_temp)
			. += "\n--Temperature: [got_told.required_temp]k"
		if(got_told.FermiChem)
			. += "\n--Temp Range: [got_told.OptimalTempMin] - [got_told.OptimalTempMax] ([got_told.ExplodeTemp])"
			. += "\n--pH Range: [got_told.OptimalpHMin] - [got_told.OptimalpHMax] ([got_told.ReactpHLim])"
		to_chat(user, .)
		QDEL_NULL(got_told)
	else ..()

/obj/item/teller/bartender/_catch()
	var/pickle = pick(cached_catched)
	got_told = new pickle
	var/datum/reagent/id = got_told.id
	. = initial(id.name)
