/datum/job/ms13/raiders/raider
	title = "Raider"
	total_positions = -1
	spawn_positions = -1
	supervisors = "nobody"
	description = "Survive and be the scourge of the wasteland. You hold no loyalty to any particular gang -- not yet, anyways."
	forbid = ""
	enforce = ""

	outfit = /datum/outfit/job/ms13/raiders/raider

	display_order = JOB_DISPLAY_ORDER_MS13_RAIDER

/datum/outfit/job/ms13/raiders/raider
	name = "_Raider"
	jobtype = /datum/job/ms13/raiders/raider

	id = 		/obj/item/card/id/ms13/raider

/datum/outfit/job/ms13/raiders/raider/pre_equip(mob/living/carbon/human/H)
	..()

	head = pick(
		/obj/item/clothing/head/ms13/hood/banded,\
		/obj/item/clothing/head/ms13/hood/sack/metal,\
		/obj/item/clothing/head/helmet/ms13/junk,\
		/obj/item/clothing/head/ms13/hood/sack/padded,\
		/obj/item/clothing/head/helmet/ms13/bladed,\
		/obj/item/clothing/head/helmet/ms13/flight,\
		/obj/item/clothing/head/helmet/ms13/flight/yellow,\
		/obj/item/clothing/head/helmet/ms13/flight/red,\
		/obj/item/clothing/head/helmet/ms13/batter/blue,\
		/obj/item/clothing/head/ms13/hood/hunter,\
		/obj/item/clothing/head/helmet/ms13/eyebot)

	belt = pick(
		/obj/item/knife/ms13, \
		/obj/item/knife/ms13/switchblade/razor, \
		/obj/item/ms13/hammer, \
		/obj/item/ms13/knuckles, \
		/obj/item/ms13/brick, \
		/obj/item/ms13/handsaw, \
		/obj/item/knife/ms13/throwingknife)

	suit = pick(
		/obj/item/clothing/suit/ms13/raider,\
		/obj/item/clothing/suit/ms13/raider/plated,\
		/obj/item/clothing/suit/ms13/raider/kevlar)

	suit_store = pick(
		/obj/item/gun/ballistic/automatic/pistol/ms13/m10mm/military,\
		/obj/item/gun/ballistic/automatic/pistol/ms13/m10mm,\
		/obj/item/gun/ballistic/automatic/pistol/ms13/pistol45,\
		/obj/item/gun/ballistic/revolver/ms13/rev357,\
		/obj/item/gun/ballistic/revolver/ms13/rev357/police,\
		/obj/item/gun/ballistic/shotgun/automatic/ms13/sks,\
		/obj/item/gun/ballistic/revolver/ms13/rev556,\
		/obj/item/gun/ballistic/shotgun/ms13/lever/cowboy,\
		/obj/item/gun/ballistic/shotgun/ms13/lever,\
		/obj/item/gun/ballistic/revolver/ms13/caravan/sawed)

	suit_store = pick(
		/obj/item/gun/ballistic/automatic/pistol/ms13/m9mm, \
		/obj/item/gun/ballistic/automatic/pistol/ms13/pistol22, \
		/obj/item/gun/ballistic/rifle/ms13/varmint, \
		/obj/item/gun/ballistic/revolver/ms13/caravan, \
		/obj/item/gun/ballistic/revolver/ms13/rev10mm)

	shoes = pick(
        /obj/item/clothing/shoes/ms13/tan, \
		/obj/item/clothing/shoes/ms13/winter, \
		/obj/item/clothing/shoes/ms13/rag, \
		/obj/item/clothing/shoes/ms13/brownie, \
		/obj/item/clothing/shoes/ms13/crude)

	if(prob(80))
		l_pocket = pick(
			/obj/item/stack/medical/gauze/ms13/three)
	else
		l_pocket = null

	if(prob(50))
		r_pocket = /obj/item/flashlight/flare/ms13
	else
		r_pocket = null

/datum/outfit/job/ms13/raiders/raider/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/gun/ballistic/equipped_gun = H.get_item_by_slot(ITEM_SLOT_SUITSTORE)
	if(!istype(equipped_gun))
		return
	var/obj/item/ammo_casing/loaded_casing = equipped_gun.chambered || equipped_gun.magazine?.get_round(TRUE)
	//bullshit!
	if(!loaded_casing?.stack_type)
		return
	var/obj/item/ammo_casing/stacker_casing = new loaded_casing.type(H.loc)
	var/obj/item/ammo_box/magazine/ammo_stack/ammo_stack = stacker_casing.stack_with(new loaded_casing.type(H.loc))
	ammo_stack.top_off(loaded_casing.type, starting = TRUE)
	//this is fucking dumb but top_off has weird behavior
	if(length(ammo_stack.stored_ammo) > ammo_stack.max_ammo)
		stacker_casing = ammo_stack.get_round(keep = FALSE)
		qdel(stacker_casing)
	H.put_in_hands(ammo_stack)
	var/obj/item/backpack = H.get_item_by_slot(ITEM_SLOT_BACK)
	if(!backpack)
		return
	SEND_SIGNAL(backpack, COMSIG_TRY_STORAGE_INSERT, ammo_stack, null, TRUE, TRUE, FALSE)
