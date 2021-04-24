/obj/item/gun/energy/beam_rifle/pseudo
	name = "beam rifle"
	pin = /obj/item/firing_pin
	item_flags = 0
	slowdown = 0
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/energy/beam_rifle/pseudo/getinaccuracy(mob/living/user)
	return FALSE

/obj/item/gun/energy/beam_rifle/pseudo/New(Target)
	..()
	loc = Target	//nwn
	set_user(Target)

/obj/item/gun/energy/beam_rifle/pseudo/check_user(automatic_cleanup=TRUE)
	if(!istype(current_user) || !isturf(current_user.loc) || current_user.incapacitated())
		if(automatic_cleanup)
			stop_aiming()
		return FALSE
	return TRUE

/obj/item/gun/energy/beam_rifle/pseudo/delay_penalty(amount)
	aiming_time_left = CLAMP(aiming_time_left+(amount*1.5), 0, aiming_time)

/datum/action/power/tiamat_beam_rifle
	var/obj/item/gun/energy/beam_rifle/pseudo/pseudo_rifle
	var/is_active = FALSE
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/power/tiamat_beam_rifle/New(Target)
	..()
	pseudo_rifle = new(Target)

/datum/action/power/tiamat_beam_rifle/Trigger()
	is_active = !is_active
	if(is_active)
		owner.visible_message("<span class='warning'>[owner] deploys beam rifles from [p_their()] back!</span>",
						"<span class='warning'>You deploy a beam rifle from your back!</span>",
						"<span class='notice'><I>You hear machinery.</I></span>", 6)
	else
		pseudo_rifle.stop_aiming()
		owner.visible_message("<span class='notice'>[owner] places the beam rifle into [p_their()] back.</span>",
						"<span class='notice'>You put the beam rifle away.</span>",
						"<span class='notice'><I>You hear machinery.</I></span>", 6)

/datum/action/power/tiamat_beam_rifle/process()
	..()
	if(!is_active)
		return
	pseudo_rifle.process_aim()
	pseudo_rifle.zooming_angle = pseudo_rifle.lastangle
	pseudo_rifle.set_autozoom_pixel_offsets_immediate(pseudo_rifle.zooming_angle)