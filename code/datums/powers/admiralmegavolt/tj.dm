/datum/power/tj
	name = "TJ McKnight"
	action_list = list(/datum/action/power/tj_flame)
	power_args = POWERSET_TJ
	var/datum/action/power/tj_flight/flight
	var/datum/action/power/tj_hulk/hulk
	var/datum/action/power/tj_flame/flame
	desc = "<B>Hotkeys:</B><BR>\
			&#9;Shift+1 - <I>Toggle Hulk Smashing</I><BR>\
			&#9;Shift+2 - <I>Toggle Flight</I><BR>\
			&#9;<U>Combat Mode</U><BR>\
			&#9;Shift+Right Click - <I>Activate Fire Plume</I><BR>\
			<BR>\
			<B><U>EDITED STATS</U></B><BR>\
			&gt;&nbsp;&nbsp;<B>Max Health:</B> 200<BR>\
			&gt;&nbsp;&nbsp;<B>Punch Damage:</B> 15 - 25<BR>\
			&gt;&nbsp;&nbsp;<B>Threshold for hot atmospheres increased.</B><BR>\
			&gt;&nbsp;&nbsp;<B>Cannot take damage from fire.</B><BR>\
			&gt;&nbsp;&nbsp;<B>No Slowness from size.</B><BR>\
			<BR>\
			<B>Abilities</B><BR>\
			&gt;&nbsp;&nbsp;<B>Toggle Flight</B>: <I><font size=1>You can fly, but it doesn't affect your gravity.</font></I><BR>\
			&gt;&nbsp;&nbsp;<B>Toggle Destruction</B>: <I><font size=1>Be able to beat things to a pulp with hulk strength (only on harm intent)!</font></I><BR>\
			&gt;&nbsp;&nbsp;<B>Fire Plume</B> <I><font size=1>Emit a large cone of fire in front of you! Best used from a distance.</font></I><BR>\
			&nbsp;&nbsp;<B>You can pry open doors on grab intent.</B><BR>\
			&nbsp;&nbsp;<B>You can break out of cuffs immediately (when applicable).</B><BR>\
			<BR>\
			<B>Physiology<B><BR>\
			&nbsp;&nbsp;<B>Brute</B>: <font size=1>30% Reduction</font><BR>\
			&nbsp;&nbsp;<B>Burn</B>: <font size=1>30% Reduction</font><BR>\
			&nbsp;&nbsp;<B>Toxin</B>: <font size=1>30% Reduction</font><BR>\
			&nbsp;&nbsp;<B>Oxyloss</B>: <font size=1>30% Reduction</font><BR>\
			&nbsp;&nbsp;<B>Stamina Mod</B>: <font size=1>75% Reduction</font><BR>\
			&nbsp;&nbsp;<B>Shock Mod</B>: <font size=1>90% Reduction</font>"

//No speed reduction from size --
//Is flying, like an angel --
//Causes severe damage when attacking with hand --
//Force open airlocks --
//Can damage walls with harm intent --
//Bursts out of cuffs --
//High resistance to damage --
//Can breathe in harsher atmospheres --

/datum/power/tj/apply()
	//DEFENSES & DEFINES
	var/datum/physiology/P = owner.physiology		//cache for fast code :)
	P.brute_mod = P.burn_mod = P.tox_mod = P.oxy_mod = 0.70
	P.stamina_mod = 0.25
	P.siemens_coeff = 0.1
	P.fire_mod = 0
	owner.remove_movespeed_modifier("SIZECODE")	//ree keep stuff defined in better places
	owner.setMaxHealth(200)
	owner.physiology = P
	owner.dna.species.punchdamagelow = 15	//I don't know how to effectively make a new species without fucking up other stuff
	owner.dna.species.punchdamagehigh = 25
	owner.dna.species.special_step_sounds = list(
		'sound/effects/footstep/tj_stamp1.ogg',
		'sound/effects/footstep/tj_stamp2.ogg',
		'sound/effects/footstep/tj_stamp3.ogg'
	)
	
	//Organs
	var/obj/item/organ/lungs/tj/L = new()
	var/obj/item/organ/old = owner.getorganslot(ORGAN_SLOT_LUNGS)
	old.Remove(owner, TRUE)
	QDEL_NULL(old)
	L.Insert(owner)

/datum/power/tj/grant_actions()
	flight = new(owner)
	hulk = new(owner)
	flame = new(owner)
	flight.Grant(owner)
	hulk.Grant(owner)
	flame.Grant(owner)
	action_holder = list(flight, hulk, flame)
	return action_holder

/datum/power/tj/special(argument)
	. = ..()
	if(!.)
		switch(argument)
			if(POWERID_HULK_ATTACK)
				if(hulk.hulkmode)
					return TRUE

/datum/power/tj/default_key_input(key, hotkey, argument)
	if(hotkey["Shift"])
		switch(key)
			if("1")
				if(hulk)
					hulk.Trigger()
					return TRUE
			if("2")
				if(flight)
					flight.Trigger()
					return TRUE

/datum/power/tj/special_clickon(params, atom/A, hotkeys, argument)
	set waitfor = FALSE
	if(!owner.client.show_popup_menus)
		if(params["right"])
			if(hotkeys["Shift"])
				if(flame)
					flame.Trigger(A)
					return TRUE

/datum/power/tj/mob_examinate()
	. = ""
	if(owner.stat)
		return
	if(owner.is_flying() && hulk.hulkmode)
		. += "<span class='notice'>She's flapping her wings</span> <span class='warning'>and looks ready to break something.</span>"
	else if(owner.is_flying())
		. += "<span class='notice'>She's flapping her wings.</span>"
	else if(hulk.hulkmode)
		. += "<span class='warning>She looks ready to break something.</span>"

//ORGANS
/obj/item/organ/lungs/tj
	name = "dragon lungs"
	safe_oxygen_min = 4
	safe_toxins_max = INFINITY
	SA_para_min = 0 //Sleeping agent
	SA_sleep_min = 1 //Sleeping agent
	BZ_trip_balls_min = 0 //BZ gas
	gas_stimulation_min = 0 //Nitryl and Stimulum

	oxy_breath_dam_min = MIN_TOXIC_GAS_DAMAGE*4
	oxy_breath_dam_max = MAX_TOXIC_GAS_DAMAGE*4
	nitro_breath_dam_min = MIN_TOXIC_GAS_DAMAGE*4
	nitro_breath_dam_max = MAX_TOXIC_GAS_DAMAGE*4
	co2_breath_dam_min = MIN_TOXIC_GAS_DAMAGE*4
	co2_breath_dam_max = MAX_TOXIC_GAS_DAMAGE*4

	heat_level_1_threshold = PLASMA_UPPER_TEMPERATURE
	heat_level_2_threshold = 7000
	heat_level_3_threshold = 19000
	heat_level_1_damage = 3
	heat_level_2_damage = 20
	heat_level_3_damage = 40

//ACTIONS
/datum/action/power/tj_flight
	name = "Toggle Flight"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "flight"

/datum/action/power/tj_flight/Trigger()
	if(!..()) return FALSE
	owner.movement_type ^= FLYING
	to_chat(owner, "<span class='notice'>You are [(owner.movement_type & FLYING) ? "now" : "no longer"] flying.</span>")
	return TRUE

/datum/action/power/tj_hulk
	name = "Toggle Destruction"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "mutate"
	var/hulkmode = FALSE

/datum/action/power/tj_hulk/Trigger()
	if(!..()) return FALSE
	hulkmode = !hulkmode
	to_chat(owner, "<span class='warning'>You [hulkmode ? "are now capable of" : "stop"] using your full strength.</span>")
	return TRUE

/datum/action/power/tj_flame
	name = "Fire Plume"
	desc = "Spray a cone of fire in front of you! Stand still so it travels farther."
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "fireball2"
	cooldown = 300

/datum/action/power/tj_flame/Trigger(atom/target)
	if(!..()) return FALSE
	var/turf/affected = get_step(owner, owner.dir)
	if(!CANATMOSPASS(affected, owner.loc))
		next_use_time = 0
		to_chat(owner, "<span class='warning'>There's something in the way!</span>")
		return FALSE
	if(!do_after(owner, 4, target=owner))
		next_use_time = 0
		return FALSE
	owner.visible_message("<span class='warning'>[owner] breathes a cone of fire!</span>", "<span class='warning'><B>You breathe a plume of fire!</B></span>", "<span class='warning'>You hear something burning.</span>")
	playsound(affected, 'sound/magic/fireball.ogg', 200, 1)
	var/list/width = 0
	var/list/distance = 0
	var/list/hit_things = list()
	var/list/affected_x = owner.x
	var/list/affected_y = owner.y
	var/initial_x = owner.x
	var/initial_y = owner.y
	var/initial_z = owner.z
	var/previously_dense = FALSE
	var/blocked_walls = 0
	var/timer = 0
	var/dir = owner.dir
	var/turf/last_turf = locate(initial_x, initial_y, initial_z)
	var/turf/next_turf = affected

	var/datum/progressbar/bar = new(owner, 8, owner)
	while(distance <= 8)
		if(owner.stat || (initial_x != owner.x || initial_y != owner.y || initial_z != owner.z))
			break
		timer++
		bar.update(distance)
		sleep(1)
		if(!(timer % 4))	//Update every 0.4 seconds
			continue
		
	//////Get turf dependant on width
		var/list/affected_turf = list()
		var/turf/master = next_turf
		next_turf = get_step(locate(affected_x, affected_y, initial_z), dir)
		affected_x = master.x
		affected_y = master.y
		if(!previously_dense)
			if(CANATMOSPASS(master, last_turf))
				affected_turf += master
			else
				previously_dense = TRUE
		else
			if(!CANATMOSPASS(next_turf, master) || !width)
				break

		if(distance >= 5 && distance != 8)
			width++	//force a width increase, make it seem like a "bubble" of fire

	//////CORNERS REEE
		if(width)
			if(previously_dense && blocked_walls < 3)	//If we met a wall, make the fire seem like it passes around whatever wall we met
				if(width > 1)
					previously_dense++
					for(var/I in 1 to width-round(previously_dense/2))
						var/list/to_add = list()
						switch(dir)		//My knowledge with bitflags is limited so enjoy my shitcode
							if(NORTH, SOUTH)
								to_add += locate(affected_x+I, affected_y, initial_z)
								to_add += locate(affected_x-I, affected_y, initial_z)
							if(EAST, WEST)
								to_add += locate(affected_x, affected_y+I, initial_z)
								to_add += locate(affected_x, affected_y-I, initial_z)
						for(var/X in 1 to to_add.len)
							if(CANATMOSPASS(to_add[X], last_turf) && X != blocked_walls)
								affected_turf += to_add[X]	//byond ree
							else if(!blocked_walls)
								blocked_walls = X
							else if (X != blocked_walls)
								blocked_walls = 3
							
	//////When there isn't a wall
			else if (blocked_walls < 3)
				for(var/I in 1 to 2)
					var/turf/to_add = master
					for(var/X in 1 to width)
						switch(dir)		//a
							if(NORTH, SOUTH)
								to_add = get_step(to_add, EAST*I)
							if(EAST, WEST)
								to_add = get_step(to_add, NORTH*I)
						if(!CANATMOSPASS(to_add, last_turf))	//But don't add any if we ever met
							break
						affected_turf += to_add
		last_turf = master

	//////Start burning the turf
		playsound(master, 'sound/effects/bamf.ogg', 95, 0)
		for(var/turf/T in affected_turf)	//No need to skip if we're dense, code above us handles that
			new/obj/effect/hotspot/pseudo(T, owner)		//Fire, lasts around 1 second
			T.hotspot_expose(600, 50, 1)	//Make the atmos HEATED
			for(var/A in T.contents - hit_things)	//Deal 12 burn for any carbons that end up in the mix, but don't hit them twice if they happen to move away from the fire
				if(A == owner)
					continue
				if(ismob(A))
					var/mob/M = A
					hit_things += M
					if((M.resting || M.lying) && M != target)	//Let mobs on the ground avoid getting burned unless they were clicked on.
						continue
					if(isliving(A))
						var/mob/living/L = A
						L.adjustFireLoss(12)
				
		width = min(width + prob(30*distance), 2)	//30% chance to increase width by 1 every tile, max of 2 tiles each side
		distance++
#ifdef TJ_DEBUG
	var/dat = "Initial Location: ([initial_x], [initial_y], [initial_z])<BR>\
		Timer ended at: [(timer/10)*4] seconds<BR>\
		Hit Things length: [hit_things.len]<BR>\
		Master met object which didn't like atmos: [previously_dense ? "Yes" : "No"]<BR>\
		Final Distance: [distance]<BR>\
		Final Width: [width]"
	owner << browse(dat, "window=debug")
#endif
	qdel(bar)
	next_use_time = world.time + cooldown - timer
	return TRUE
