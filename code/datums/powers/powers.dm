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
