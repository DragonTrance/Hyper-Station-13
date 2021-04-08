#define POWER_LAZY_CREATE(POW, mob) new/datum/power/##POW(mob)
#define POWER_CHECK(POW) (istype(POW, /datum/power))
//#define POWER_TRANSFER_OWNERSHIP(user) (GLOB.power_master.transfer_ownership(user))
#define POWER_ASSUME(user, arg) (GLOB.power_master.assume_special(user, arg))
#define POWER_KEY_DOWN(user, arg, key, hotkey) (GLOB.power_master.assume_key(user, arg, key, hotkey))
#define POWER_CLICKON(user, params, A, hotkeys, argument) GLOB.power_master.assume_clickon(user, params, A, hotkeys, argument)
#define POWER_EXAMINATE(user) GLOB.power_master.assume_examinate(user)
#define POWER_TIDBIT(user) GLOB.power_master.get_tidbit(user)

#define POWERSET_TJ list(POWERID_SIZE_SPEED, POWERID_FORCE_DOORS, POWERID_FORCE_RESTRAINTS, \
	POWERID_FORCE_RESTRAINTS_TEXT, POWERID_HEAVY_FOOTSTEPS, POWERID_FLYING_WING_NOISES, POWERID_FAST_FLYING_FLAVOR)
#define POWERID_SIZE_SPEED "size_speed"
#define POWERID_DNA_FLIGHT "dna_flight"
#define POWERID_FORCE_DOORS "force_doors"
#define POWERID_FORCE_RESTRAINTS "force_restraints"
#define POWERID_FORCE_RESTRAINTS_TEXT "force_restraints_text"
#define POWERID_HULK_ATTACK "hulk_attack"
#define POWERID_HEAVY_FOOTSTEPS "heavy_footsteps"
#define POWERID_FLYING_WING_NOISES "flying_wing_noises"
#define POWERID_FAST_FLYING_FLAVOR "fast_flying_flavor"

//#define TJ_DEBUG