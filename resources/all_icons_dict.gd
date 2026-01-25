class_name AllIconsDictionary
extends Resource

enum Types {
	NONE,
	BLIGHT, BLEED, BURN,
	BLOCK, BLOCK_PLUS, DODGE, DODGE_PLUS, GUARD, RIPOSTE, STEALTH, STRENGTH, CRIT, POSITIVE,
	BLIND, DAZE, STUN, TAUNT, VULN, WEAK, IMMOBILIZE, NEGATIVE,
	COMBO, MOVE, REGEN, STRESS, SPEED, HEAL, EXECUTE, DEATHSDOOR,
	WINDED, RUINING, RUIN, POWER, CONVICTION, CONSECRATION, TOXIC, AGGRESIVE, DEFENSIVE,
	FAST,
	SMALL_MELEE, SMALL_RANGED, SMALL_HEAL, SMALL_ANTISTRESS, UPGRADE,
	DISEASE,
}

const ICON_TYPE: Dictionary[StringName, Types] = {
	&"$blt": Types.BLIGHT,
	&"$bld": Types.BLEED,
	&"$brn": Types.BURN,
	
	&"$blk": Types.BLOCK,
	&"$blk+": Types.BLOCK_PLUS,
	&"$ddg": Types.DODGE,
	&"$ddg+": Types.DODGE_PLUS,
	&"$grd": Types.GUARD,
	&"$rps": Types.RIPOSTE,
	&"$stl": Types.STEALTH,
	&"$str": Types.STRENGTH,
	&"$crt": Types.CRIT,
	&"$fst": Types.FAST,
	&"$pos": Types.POSITIVE,
	
	&"$bln": Types.BLIND,
	&"$dze": Types.DAZE,
	&"$stn": Types.STUN,
	&"$tnt": Types.TAUNT,
	&"$vln": Types.VULN,
	&"$vvk": Types.WEAK,
	&"$imm": Types.IMMOBILIZE,
	&"$neg": Types.NEGATIVE,
	
	&"$cmb": Types.COMBO,
	&"$mve": Types.MOVE,
	&"$reg": Types.REGEN,
	&"$sts": Types.STRESS,
	&"$spd": Types.SPEED,
	&"$hlh": Types.HEAL,
	&"$exe": Types.EXECUTE,
	&"$dth": Types.DEATHSDOOR,
	&"$dss": Types.DISEASE,
	
	&"$wnd": Types.WINDED,
	&"$rnn": Types.RUINING,
	&"$rui": Types.RUIN,
	&"$pow": Types.POWER,
	&"$cnv": Types.CONVICTION,
	&"$cns": Types.CONSECRATION,
	&"$tox": Types.TOXIC,
	&"$agr": Types.AGGRESIVE,
	&"$def": Types.DEFENSIVE,

	&"$tml": Types.SMALL_MELEE,
	&"$trg": Types.SMALL_RANGED,
	&"$thl": Types.SMALL_HEAL,
	&"$tst": Types.SMALL_ANTISTRESS,

	&"$upg": Types.UPGRADE,
}

@export var dict: Dictionary[Types, Texture2D]


func get_texture(icon_name: String) -> Texture2D:
	var type := ICON_TYPE[icon_name]
	var texture := dict[type]
	if texture != null:
		return texture
	return null
