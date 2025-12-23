class_name AllIconsDictionary
extends Resource

enum Types {
	NONE,
	BLIGHT, BLEED, BURN,
	BLOCK, BLOCK_PLUS, DODGE, DODGE_PLUS, GUARD, RIPOSTE, STEALTH, STRENGTH, CRIT, POSITIVE,
	BLIND, DAZE, STUN, TAUNT, VULN, WEAK, IMMOBILIZE, NEGATIVE,
	COMBO, MOVE, REGEN, STRESS, SPEED, HEAL, EXECUTE,
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
	&"$bff": Types.POSITIVE,
	
	&"$bln": Types.BLIND,
	&"$dze": Types.DAZE,
	&"$stn": Types.STUN,
	&"$tnt": Types.TAUNT,
	&"$vln": Types.VULN,
	&"$vvk": Types.WEAK,
	&"$imm": Types.IMMOBILIZE,
	&"$dbf": Types.NEGATIVE,
	
	&"$cmb": Types.COMBO,
	&"$mve": Types.MOVE,
	&"$reg": Types.REGEN,
	&"$sts": Types.STRESS,
	&"$spd": Types.SPEED,
	&"$hlh": Types.HEAL,
	&"$exe": Types.EXECUTE,
}

@export var dict: Dictionary[Types, Texture2D]


func get_texture_path(icon_name: String) -> String:
	var type := ICON_TYPE[icon_name]
	var texture := dict[type]
	if texture != null:
		return texture.resource_path
	return ""
