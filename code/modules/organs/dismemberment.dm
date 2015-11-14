//All stuff related to dismemberment goes here. |- Ricotez

/datum/dismember_stats/
	var/can_dismember 			= 0		//Set to 1 if this weapon can dismember arms and legs.
	var/can_behead 				= 0		//Set to 1 if this weapon can dismember heads.
	var/dismember_threshold 	= 0		//Set to the damage the limb needs to have before this weapon can dismember it. As of writing, the max damage for a limb is 75.
	var/behead_threshold 		= 0		//Set to the damage the head needs to have before this weapon can dismember it. As of writing, the max damage for a head is 200.
	var/dismember_prob 			= 0		//Set the probability that this weapon dismembers if the conditions are met.
	var/behead_prob				= 0		//Set the probability that this weapon beheads if the conditions are met.
	var/dismember_nobleed		= 0		//Set whether the weapon instantly cauterizes a limb upon dismemberment. eg. eswords are so hot they seal the wound up.

//So you don't have to set this shit individually for each and every item. Needs balancing obviously
/datum/dismember_stats/cant_dismember
	can_dismember = 0
	can_behead = 0

/datum/dismember_stats/high
	can_dismember = 1
	can_behead = 1
	dismember_threshold = 0
	behead_threshold = 0
	dismember_prob = 75
	behead_prob = 45

/datum/dismember_stats/medium
	can_dismember = 1
	can_behead = 1
	dismember_threshold = 25
	behead_threshold = 50
	dismember_prob = 50
	behead_prob = 15

/datum/dismember_stats/low
	can_dismember = 1
	can_behead = 0
	dismember_threshold = 50
	dismember_prob = 20

/datum/dismember_stats/high/nobleed
	dismember_nobleed = 1

/datum/dismember_stats/medium/nobleed
	dismember_nobleed = 1

/datum/dismember_stats/low/nobleed
	dismember_nobleed = 1

//This proc is called in attacked_by() which you can find in item_attack.dm, and it assumes that the weapon already made contact with the body part.
//All this proc does is determine if the weapon can dismember the target limb, and then dismember it with the given probability.
/datum/dismember_stats/proc/handle_dismemberment(var/datum/organ/limb/limbdata)
	var/obj/item/organ/limb/L = limbdata.organitem
	//In this big check we determine if this weapon has met the conditions to cut off this limb.
	if((can_behead && L.name == "head" && limbdata.exists() && (L.brute_dam + L.burn_dam >= behead_threshold) && prob(behead_prob)) || (can_dismember && can_be_dismembered(limbdata.name) && limbdata.exists() && (L.brute_dam + L.burn_dam >= dismember_threshold) && prob(dismember_prob)))
		if(dismember_nobleed)
			return limbdata.dismember(ORGAN_NOBLEED)
		else
			return limbdata.dismember(ORGAN_DESTROYED)
	return null

//THIS PROC DOES NOT INCLUDE HEADS BECAUSE BEHEADING IS DEALT WITH SEPARATELY!
//Weapons with dismember_stats/low can't behead
/datum/dismember_stats/proc/can_be_dismembered(var/limbname)
	return (limbname == "l_arm" || limbname == "r_arm" || limbname == "l_leg" || limbname == "r_leg")

/obj/item/weapon/
	var/datum/dismember_stats/dismember_stats = new/datum/dismember_stats/cant_dismember/

/obj/item/projectile/
	var/datum/dismember_stats/dismember_stats = new/datum/dismember_stats/cant_dismember/

/obj/proc/handle_dismemberment(var/datum/organ/limb/limbdata)
	return

/obj/item/weapon/handle_dismemberment(var/datum/organ/limb/limbdata)
	return dismember_stats.handle_dismemberment(limbdata)

/obj/item/projectile/handle_dismemberment(var/datum/organ/limb/limbdata)
	return dismember_stats.handle_dismemberment(limbdata)