/*
These contain gifts of each department. For non-holiday presents, see /obj/item/a_gift/proc/get_gift_type() in code/game/items/gift
*/

/obj/item/a_gift/holiday	//Shouldn't be used by itself in-game, just gives coal
	name = "christmas gift"
	desc = "It could be anything!"
	var/gift_possibilities = list()

/obj/item/a_gift/holiday/get_gift_type()
	message_admins("[locate(/obj/item/disk/nuclear)]")
	if (prob(10) || !gift_possibilities?.len)
		return /obj/item/trash/coal /*TODO: change to new coal after PR*/

	var/G = pick(gift_possibilities)
	return G

/obj/item/a_gift/holiday/proc/getItemDetail(var/D)
	return

/obj/item/a_gift/holiday/service
	name = "service present"
	desc = "TODO: Description"

/obj/item/a_gift/holiday/service/get_gift_type()
	if (prob(10))
		return /obj/item/trash/coal /*TODO: change to new coal after PR*/
	gift_possibilities += getItemDetail("xenoarch seeds")
	return pick(gift_possibilities)


//For items that have modified default variables, so path references can't be made
/obj/item/a_gift/holiday/service/getItemDetail(var/D)
	switch (D)
		if ("xenoarch seeds")
			var/O = pick(list(/obj/item/seeds/amauri,
				/obj/item/seeds/gelthi,
				/obj/item/seeds/jurlmah,
				/obj/item/seeds/nofruit,
				/obj/item/seeds/surik,
				/obj/item/seeds/shand,
				/obj/item/seeds/telriis,
				/obj/item/seeds/thaadra,
				/obj/item/seeds/vale,
				/obj/item/seeds/vaporsac))
			var/obj/item/seeds/I = new O(1,1,1)	//Fake nullspace
			I.yield = rand(0,3)
			I.potency = rand(10,30)
			if (prob(10))
				I.potency = 75
			return I
		if ("data disk")
			var/obj/item/disk/plantgene/I = new /obj/item/disk/plantgene(1,1,1)	//Fake nullspace
			var/datum/plant_gene/core/O
			var/N
			switch(rand(1, 3))
				if (1)
					N = round(rand(50, 100), 5)
					O = /datum/plant_gene/core/potency
					O.value = N
					I.gene = O
					I.name = "Potency [N] (plant data disk)"
				if (2)
					N = rand(1, 10)
					O = /datum/plant_gene/core/yield
					O.value = N
					I.gene = O
					I.name = "Yield [N] (plant data disk)"
				if (3)
					N = rand(2, 4)
					O = /datum/plant_gene/core/production
					O.value = N
					I.gene = O
					I.name = "Production Speed [N] (plant data disk)"
			return I
		if ("carp")	//Don't worri, it's ded!
			var/mob/living/simple_animal/hostile/carp/M
			M.stat = 3
			M.adjustHealth(20, TRUE, TRUE)
			return M
		if ("angelcake")
			var/O
			return O
		if ("bartender flask")
			var/I
			return I
		if ("nuke cola")
			var/I
			return I


/obj/item/a_gift/holiday/service/hydroponics
	name = "hydroponics present"
	desc = "TODO: Description"

/obj/item/a_gift/holiday/service/hydroponics/get_gift_type()
	gift_possibilities = list(/obj/item/seeds/random,
		/obj/item/reagent_containers/food/snacks/grown/kudzupod,
		/obj/item/reagent_containers/food/snacks/grown/apple/gold,
		/obj/item/reagent_containers/food/snacks/grown/citrus/orange_3d,
		/obj/item/reagent_containers/food/snacks/grown/berries/glow,
		/obj/item/reagent_containers/food/snacks/grown/mushroom/glowshroom/glowcap,
		/obj/effect/decal/cleanable/ash,
		/mob/living/simple_animal/hostile/killertomato)
	gift_possibilities += getItemDetail("xenoarch seeds")\
		+ getItemDetail("data disk")\
		+ getItemDetail("data disk")
	return ..()