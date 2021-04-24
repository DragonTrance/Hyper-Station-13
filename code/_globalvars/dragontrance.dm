GLOBAL_LIST_INIT(character_power_authentication, list(
	"admiralmegavolt"	= list("TJ McKnight", "Tiamat-B"),
	"dragontrance"		= list("Dendrite"),
	"spookyeet"			= list("Freya"),
	"sigmarine"			= list("Vaas'al Dekuna", "Levi Andersea"),
	"squiddly"			= list("Sissit Cillsot"),
	"pappavol"			= list("Kuba Leach"),
	"ridley41"			= list("Attacus Cunilinea")
))

GLOBAL_LIST_INIT(character_power_superiors, list(
	"dragontrance"
))

GLOBAL_LIST_INIT(power_character_names, list(
	"TJ McKnight"	= /datum/power/tj,
	"Tiamat-B"		= /datum/power/tiamat
))
GLOBAL_VAR_INIT(debug_character_setup, FALSE)
GLOBAL_LIST_INIT(power_list, list())
GLOBAL_DATUM_INIT(power_master, /datum/power_master, new/datum/power_master())
