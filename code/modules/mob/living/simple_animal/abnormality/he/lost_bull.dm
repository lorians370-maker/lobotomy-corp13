/mob/living/simple_animal/hostile/abnormality/lost_bull
	name = "Lost Bull"
	desc = "Jast lost bull, who want find road to home"
	icon = 'Neo-naser/bull/basic.dmi'
	icon_state = "lost_bull"
	portrait = "lost_bull"

	maxHealth = 350
	health = 350
	move_to_delay = 2

	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 60, 80, 80),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 30, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 30, 30, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 60, 80, 80),
	)
	work_damage_upper = 5
	work_damage_lower = 3
	work_damage_type = RED_DAMAGE

	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
	melee_damage_lower = 1
	melee_damage_upper = 3
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'

	ego_list = list(
	)

	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL
	chem_type = /datum/reagent/abnormality/sin/gloom

	var/splash_cooldown
	var/splash_cooldown_time = 2 SECONDS

	//Observation is mostly mirror dungeon but with some changed phrasing
	observation_prompt = "Перед лицом проносятся сцены, что ты никогда не мог видеть. <br>\
		Ты был рожден весь в крови, и остался с ней когда вырос. <br>\
		Красный, быстрый, смертноносный. <br>\
		Когда то ты сражался, вместе со своими братьями. <br>\
		Защищал дом, то что тебе дорого. Мать и семью. <br>\
		Но теперь ты здесь, вечно в душной камере, обреченный на столь же вечные муки."
	observation_choices = list(
		"Я начинаю свой бег" = list(TRUE, "Моя голова сама наклоняется для удара. <br>\
			\"БАМ!\ <br>\
			Все что осталось после видений, это дизоорентация <br>\
			и почему то начинает болеть верхушка головы."),
		"Я начинаю свою эволюцию" = list(FALSE, "Моя ярость освободит меня. <br>\
			Но мне не хватило сил. Не было плазмы. Все что осталось после видений - разочарование"),
	)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/BreachEffect(mob/living/carbon/human/user, breach_type)
	..()
	AddElement(/datum/element/waddling)
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/AttackingTarget(atom/attacked_target)
	splash()
	..()

/mob/living/simple_animal/hostile/abnormality/lost_bull/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(splash_cooldown <= world.time)
		playsound(src, 'sound/abnormalities/ichthys/hardslap.ogg', 60, 1)
		splash()


/mob/living/simple_animal/hostile/abnormality/lost_bull/proc/splash()
	new /obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin(loc)
	splash_cooldown = world.time + splash_cooldown_time

/obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid/enkephalin)
	gibamounts = list(5)

/obj/effect/decal/cleanable/wrath_acid/enkephalin
	name = "Enkephalin"
	desc = "There are some harsh fumes coming off of it."
	icon_state = "acid_greyscale"
	random_icon_states = list("acid_greyscale")
	color = "#20f8ac"
	duration = 30 SECONDS

/obj/effect/decal/cleanable/wrath_acid/enkephalin/Crossed(atom/movable/AM)
	if(!ishuman(AM))
		return FALSE
	var/mob/living/carbon/human/H = AM
	H.apply_damage(1, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	. = ..()
