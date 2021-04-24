/datum/power/tiamat
	name = "Tiamat-B"
	power_args = POWERSET_TIAMAT
	//actions_on_new = FALSE
	var/datum/action/power/holder/tiamat/powers
	desc = "Ctrl+Shift+V - Switch Piercing<BR>\
			Shift+V (Combat Mode) - Zoom<BR>\
			Shift+1 - Hulky Mode"

/*
TODO REEE
,, "Booting" process when first appearing. Make blind and deaf during this, bold flavortext to make "Unknown says something but you cannot hear it!" less noticeable
-- Master "holder" action, which can show and hide a set of actions
,, Light EMP: Burn damage
,, Heavy EMP: Blindness and deaf for a few seconds
,, Robotic bodyparts
,, Slight speed increase
-- 200% Size, no speed reduction
,, Resistance to Brute and Burn, ask how much
,, Complete resistance to Toxin, Radiation, Cellular and Organ damage. Make custom organs for this
,, Immune to blinding and deafness, with the exception of EMPs
-- Cannot bleed. Amazing how physiology already has that, as well as a trait, maybe
,, Doesn't need to eat or drink. Now this is definite trait stuff
,, WEAPONS, which can be taken out or activated with actions:
	,, Particle Cannon, works like Particle Accelerator from research. Click where to shoot. Tie with hotkey?
	,, A single machine gun, which auto-equips as a QDEL_DROP item. SHOOTS FUCKING DEATHSQUAD REVOLVER AMMO, MAYBE NERF THAT
	,,
,, Thrusters. AKA Ion Thrusters for borg, or a jetpack. Tie with action
,, Energy Shield from a Durand. Tie with action, give cooldown
,, Magboots ability, again activated with actions. Steal some claw art from furaffinity or something for the icon
,, Cannot be slowed or sped by turf, and stepping on glass gives no damage. Shatter glass like tgmc?
,, No damage from the atmosphere or from breathing in toxins, besides higher heat
-- Take some damage from high heat
,, Complete immunity to Stuns, Slowness (no way to edit this without heavy code editing), Shoved, or Knocked out. status_flags = 0
,, Can walk over tables without the need to TK them. Destroys wood and glass tables, but not plasmaglass
,, Can pry open doors and break down walls with hulk power like TJ
,, Cannot be cuffed. At all. Reeeee
,, Massively increased punch/slash damage. With fun things, ask about the stun!
,, Can automatically catch objects thrown to her, even without throw intent or the active hand being available
,, Passive Arm Stimulation trait, from DNA vault
,, Knows CQC
,, Hitting welded airlocks with harm intent and an empty hand unwelds them

,, TODO: Fix TJ not able to break through zipties
*/

/datum/power/tiamat/apply()

/datum/power/tiamat/grant_actions()
	//powers = new(owner)
	//powers.Grant(owner)

//
//KEY BINDINGS
/datum/power/tiamat/default_key_input(key, hotkey, argument)
	if(hotkey["Ctrl"] && hotkey["Shift"])
		switch(key)
			if("V")
				if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
					if(!powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle)
						return FALSE
					if(istype(owner.get_active_held_item(), /obj/item/gun/energy/beam_rifle))
						return FALSE
					if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
						powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle?.attack_self(owner)
						return TRUE
				return FALSE
	if(hotkey["Shift"])
		switch(key)
			if("1")
				if(powers.actions[POWERDATUM_TJ_HULK])
					powers.actions[POWERDATUM_TJ_HULK].Trigger()
					return TRUE
			if("V")
				if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
					if(!powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle)
						return FALSE
					if(istype(owner.get_active_held_item(), /obj/item/gun/energy/beam_rifle))
						return FALSE
					var/obj/item/gun/energy/beam_rifle/pseudo/rifle = powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle
					if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
						if(owner.client.show_popup_menus)
							return FALSE
						if(rifle.zooming)
							rifle.stop_zooming()
						else
							rifle.start_zooming()
						return TRUE
					else
						rifle.stop_zooming()
						return FALSE

//
//MOUSE DRAG & CLICKING
/datum/power/tiamat/special_click_down(object, location, control, params)
	if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
		if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
			powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle?.onMouseDown(object, location, params, owner)
			return TRUE

/datum/power/tiamat/special_clickon(params, atom/A, hotkeys, argument)
	//Same as click_up except i don't know why click_up doesn't work, so this works for now
	if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
		if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
			powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle?.onMouseUp(A, owner.client.mouseLocation, params, owner)
			return TRUE

/*/datum/power/tiamat/special_click_up(object, location, control, params)
	if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
		if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
			powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle?.onMouseUp(object, location, params, owner)
			return TRUE*/

/datum/power/tiamat/special_mouse_drag(src_object,over_object,src_location,over_location,src_control,over_control,list/params)
	if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE])
		if(powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.is_active)
			powers.actions[POWERDATUM_TIAMAT_BEAM_RIFLE]?.pseudo_rifle?.onMouseDrag(src_object, over_object, src_location, over_location, params, owner)
			return TRUE
//
//

/datum/action/power/holder/tiamat
	name = "Tiamat's Abilities"
	actions = list(/datum/action/power/tj_hulk, /datum/action/power/tiamat_beam_rifle)

/datum/action/power/machine_gun