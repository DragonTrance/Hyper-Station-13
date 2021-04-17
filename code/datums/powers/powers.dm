/datum/power
	var/name = "characternamehere"
	var/desc = ""
	var/apply_on_new = TRUE
	var/mob/living/carbon/human/owner
	var/ckey
	var/list/action_list = list()
	var/list/action_holder = list()
	var/actions_on_new = TRUE
	var/actions_given = FALSE
	var/list/power_args = list()

/datum/power/New(mob/living/target)
	if(!istype(target))
		return

	owner = target
	if(!owner.client)
		QDEL_IN(src, 0)
		return

	ckey = owner.client.ckey
	owner.power = src
	GLOB.power_list[owner.client.ckey] += src

	if(actions_on_new)
		grant_actions()
	if(apply_on_new)
		apply()
		after_apply()

/datum/power/Destroy()
	if(actions_given)
		for(var/datum/action/A in action_list)
			A.Remove()
		QDEL_NULL_LIST(action_list)
	..()

/datum/power/proc/grant_actions()
	if(!action_list.len)
		return list()
	if(action_holder.len)
		QDEL_NULL_LIST(action_holder)
	actions_given = TRUE
	for(var/X in action_list)
		var/datum/action/A = new X(owner)
		action_holder += A
		A.Grant(owner)

	return action_holder

/datum/power/proc/default_key_input(key, hotkey, argument)
	return FALSE

/datum/power/proc/apply()
	return FALSE

/datum/power/proc/after_apply()
	return FALSE

/datum/power/proc/special(argument)
	return (power_args.Find(argument))

/datum/power/proc/mob_examinate()
	return ""

/datum/power/proc/tidbit()
	return desc

/datum/power/proc/special_clickon(params, atom/A, hotkeys, argument)
	return FALSE	//Without lag between clicks

/datum/power/proc/special_click_down(object, location, control, params)
	return FALSE	//There is lag on clicks

/datum/power/proc/special_click_up(object, location, control, params)
	return FALSE

/datum/power/proc/special_mouse_move(location, object, control, list/params)
	return FALSE

/datum/power/proc/special_mouse_drag(src_object,over_object,src_location,over_location,src_control,over_control,list/params)
	return FALSE

/datum/power/proc/special_mouse_drop(src_object,over_object,src_location,over_location,src_control,over_control,list/params)
	return FALSE



/datum/power_master/proc/check_applicable(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	if(!user.power)
		return
	return TRUE

/datum/power_master/proc/transfer_ownership(mob/living/carbon/human/user, mob/living/carbon/human/new_user)
	if(check_applicable(user))
		for(var/datum/action/A in user.power.action_holder)
			A.Remove(user)
		user.power.New(new_user)
		new_user.power = user.power
		return TRUE
	return FALSE

/datum/power_master/proc/assume_special(mob/living/carbon/human/user, argument)
	if(check_applicable(user))
		return user.power.special(argument)

/datum/power_master/proc/assume_key(mob/living/carbon/human/user, argument, key, hotkey)
	if(check_applicable(user))
		return user.power.default_key_input(key, hotkey, argument)

/datum/power_master/proc/assume_clickon(mob/living/carbon/human/user, params, A, hotkeys, argument)
	if(check_applicable(user))
		return user.power.special_clickon(params, A, hotkeys, argument)

/datum/power_master/proc/assume_mouseDown(mob/living/carbon/human/user, object, location, control, params)
	if(check_applicable(user))
		return user.power.special_click_down(object, location, control, params)

/datum/power_master/proc/assume_mouseUp(mob/living/carbon/human/user, object, location, control, params)
	if(check_applicable(user))
		return user.power.special_click_up(object, location, control, params)

/datum/power_master/proc/mouse_move(mob/living/carbon/human/user, location, object, control, list/params)
	if(check_applicable(user))
		return user.power.special_mouse_move(location, object, control, params)

/datum/power_master/proc/mouse_drag(mob/living/carbon/human/user,mode,src_object,over_object,src_location,over_location,src_control,over_control,list/params)
	if(!check_applicable(user))
		return FALSE
#ifdef POWER_DEBUG
	.="";for(var/X in params){.+="[X], "}
	to_chat(owner, "<B>Mode</B>: [mode]\nsrc_object: [src_object]\nover_object: [over_object]\nsrc_location: [src_location]\nover_location: [over_location]\nsrc_control: [src_control]\nover_control: [over_control]\nparams: [params.len ? "[.]" : "none"]")
#endif
	switch(mode)
		if("drag")
			return user.power.special_mouse_drag(src_object,over_object,src_location,over_location,src_control,over_control,params)
		if("drop")
			return user.power.special_mouse_drop(src_object,over_object,src_location,over_location,src_control,over_control,params)

/datum/power_master/proc/assume_examinate(mob/living/carbon/human/user)
	if(check_applicable(user))
		return user.power.mob_examinate()

/datum/power_master/proc/get_tidbit(mob/living/carbon/human/user)
	if(check_applicable(user))
		return user.power.tidbit()

/datum/power_master/Topic(href,href_list[],hsrc)
	if(href_list["S"])
		var/datum/power/power = locate(href_list["S"])
		var/mob/living/carbon/human/H = power.owner
		if(!istype(H))
			return
		var/datum/browser/popup = new(H, "power_master_topic_thing_i_can_have_these_as_long_as_i_want", "[power.name]", 384, 420)
		popup.set_content(power.tidbit())
		popup.open()

/datum/power_master/proc/display_tidbit(mob/living/carbon/human/user)
	if(check_applicable(user))
		var/datum/browser/popup = new(user, "", user.real_name, 500, 800)
		popup.set_content(user.power.tidbit())
		popup.open()


//ACTIONS
/datum/action/power
	var/datum/power/host_power
	var/cooldown = 0
	var/next_use_time = 0
	check_flags = AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	transparent_when_unavailable = FALSE
	background_icon_state = "bg_tech"

/datum/action/power/New(Target)
	if(ishuman(Target))
		var/mob/living/carbon/human/H = Target
		if(H.power)
			host_power = H.power
			START_PROCESSING(SSfastprocess, src)
			return ..()
	QDEL_IN(src, 0)

/datum/action/power/process()
	if(cooldown)
		UpdateButtonIcon()

/datum/action/power/IsAvailable()
	if(!..())
		return FALSE
	return (next_use_time < world.time)

/datum/action/power/Trigger()
	if(!..())
		return FALSE
	next_use_time = world.time + cooldown
	return TRUE

/datum/action/power/holder
	name = "Abilities"
	var/list/actions = list()
	var/show_on_new = TRUE
	var/showing = TRUE

/datum/action/power/holder/New(Target)
	to_chat(Target, "New: Actions length is [actions.len].")
	if(!actions.len)
		to_chat(Target, "Actions have no length, doin da funky")
		return
	..()
	to_chat(Target, "After ..(): Actions length is [actions.len].")
	to_chat(Target, "Actions.Copy() = [actions.Copy()].")
	var/list/cached_actions = actions
	to_chat(Target, "cached_actions = [cached_actions].")
	actions = list()
	to_chat(Target, "After everything: Actions length is [actions.len], cached_actions is [cached_actions].")
	to_chat(Target, "cached_actions has a length of [cached_actions.len].")
	for(var/X in cached_actions)
		var/datum/action/A = new X(Target)
		to_chat(Target, "Went through [A] to add")
		A.Grant(Target)
		actions["[A.type]"] = A

	if(show_on_new)
		showing = TRUE
		button_icon_state = "hide"
		name = "Hide [initial(name)]"
	else
		showing = FALSE
		button_icon_state = "show"
		name = "Show [initial(name)]"
		for(var/A in actions)
			hide_action(actions[A])
	if(ismob(Target))
		var/mob/M = Target
		M.update_action_buttons(TRUE)
	to_chat(Target, "End")

/datum/action/power/holder/Trigger()
	showing = !showing
	if(showing)
		button_icon_state = "hide"
		name = "Hide [initial(name)]"
		for(var/A in actions)
			hide_action(actions[A])
	else
		button_icon_state = "show"
		name = "Show [initial(name)]"
		for(var/A in actions)
			show_action(actions[A])
	owner.update_action_buttons(TRUE)

/datum/action/power/holder/proc/show_action(datum/action/A)
	A.button.moved = null
	A.button.ordered = TRUE

/datum/action/power/holder/proc/hide_action(datum/action/A)
	A.button.moved = "1:-999,1:-999"	//Fake nullspace. Moving the absolute location to 0 or less will /really/ fuck with stuff
	A.button.ordered = FALSE

/datum/action/power/holder/IsAvailable()
	return TRUE

/datum/action/power/conjure_item
	var/obj/item/item
	var/deployed = FALSE

/datum/action/power/conjure_item/New(Target)
	if(!item)
		return
	..()
	if(!icon_icon)
		icon_icon = item.icon
	if(!button_icon_state)
		button_icon_state = item.icon_state
	item = new()
	ADD_TRAIT(item, TRAIT_NODROP, GLUED_ITEM_TRAIT)

/datum/action/power/conjure_item/IsAvailable()
	if(!..())
		return FALSE
	var/obj/item/I = owner.get_active_held_item()
	if(I && I != item)
		return FALSE
	return !deployed

/datum/action/power/conjure_item/Trigger()
	if(!..())
		return FALSE
	if(item == owner.get_active_held_item())
		deployed = !owner.temporarilyRemoveItemFromInventory(item, TRUE)
	else
		if(!owner.equip_to_slot_if_possible(item, owner.active_hand_index, FALSE, TRUE, TRUE, TRUE, FALSE))
			to_chat(owner, "<span class='warning'>You cannot equip that!</span>")
		else
			deployed = TRUE
	return TRUE
