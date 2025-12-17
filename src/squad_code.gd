class_name SquadCode
extends Object

const B64URL := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"


static func encode_squad(data: Dictionary) -> String:
	var code := ""
	for slot in ["1", "2", "3", "4"]:
		var slot_data: Dictionary = data[slot]
		var hero_path: int = slot_data["hero_path"]
		if hero_path == Data.HeroesPaths.NONE:
			return ""
		
		assert(hero_path >= 0 and hero_path < 64)
		
		code += B64URL[hero_path]
		
		var skills: Array[int] = []
		skills.assign(slot_data["skills"])
		var count := 9 if _needs_9_skills(hero_path) else 5
		
		var packed := _skills_to_int(skills)
		var skill_len := 6 if count == 9 else 3
		code += _b64_encode_fixed(packed, skill_len)
	
	# Keep squad_name readable, but make it safe for the delimiter.
	# (If you truly want it raw, you must forbid '|' in names.)
	var name := String(data.get("squad_name", ""))
	return code + "|" + name.uri_encode()


static func decode_squad(text: String) -> Dictionary:
	var pipe_index := text.find("|")
	if pipe_index == -1:
		return {}
	
	var code := text.substr(0, pipe_index)
	var name := "" if text.length() == pipe_index + 1 else text.substr(pipe_index + 1).uri_decode()
	
	var out: Dictionary = { "squad_name": name }
	
	var index := 0
	for slot in ["1", "2", "3", "4"]:
		if not index < code.length():
			return {}
		
		var hero_path := _b64_value(code[index])
		index += 1
		
		var count := 9 if _needs_9_skills(hero_path) else 5
		var skill_len := 6 if count == 9 else 3
		
		if not index + skill_len <= code.length():
			return {}
		
		var skills_text := code.substr(index, skill_len)
		index += skill_len
		
		var packed := _b64_decode_fixed(skills_text)
		var skills := _int_to_skills(packed, count)
		
		out[slot] = {
			"hero_path": hero_path,
			"skills": skills
		}
	
	_validate_squad(out, code.length())
	
	return out


static func _b64_value(ch: String) -> int:
	return B64URL.find(ch)


static func _b64_encode_fixed(value: int, length: int) -> String:
	var out := ""
	for i in range(length):
		var digit := value & 63
		out = B64URL[digit] + out
		value >>= 6
	return out


static func _b64_decode_fixed(text: String) -> int:
	var value := 0
	for i in range(text.length()):
		value = (value << 6) | _b64_value(text[i])
	return value


static func _skills_to_int(skills: Array[int]) -> int:
	var value := 0
	for skill in skills:
		# skill must be 0..10
		value = value * 11 + skill
	return value


static func _int_to_skills(value: int, count: int) -> Array[int]:
	var skills: Array[int] = []
	skills.resize(count)
	for i in range(count - 1, -1, -1):
		skills[i] = value % 11
		value /= 11
	return skills


static func _needs_9_skills(hero_path: Data.HeroesPaths) -> bool:
	# safest: check by enum values explicitly
	return (
		hero_path == Data.HeroesPaths.A0
		or hero_path == Data.HeroesPaths.A1
		or hero_path == Data.HeroesPaths.A2
		or hero_path == Data.HeroesPaths.A3
	)


static func _validate_squad(out: Dictionary, code_length: int) -> bool:
	# Validate and compute expected code length from decoded data
	var expected_len := 0
	var any_a := false
	
	var used_hero_paths: Array[Data.HeroesPaths] = []
	var used_heroes: Array[StringName] = []
	
	for slot in ["1", "2", "3", "4"]:
		var slot_data: Dictionary = out[slot]
		var hero_path := slot_data["hero_path"] as Data.HeroesPaths
		
		# hero_path must be a valid enum entry (excluding NONE)
		if hero_path == Data.HeroesPaths.NONE:
			return false
		if hero_path < 0 or hero_path >= Data.HeroesPaths.size():
			return false
		if hero_path >= 64: # because we encode in 1 base64-url char
			return false
		
		# Must be unique hero (no duplicates)
		if used_hero_paths.has(hero_path):
			return false
		used_hero_paths.append(hero_path)
		
		# Type letter uniqueness (first letter of enum name)
		var hero := StringName(Data.hero_path_to_hero(hero_path))
		if used_heroes.has(hero):
			return false
		used_heroes.append(hero)
		
		# Determine skills count for this hero
		var count := 9 if _needs_9_skills(hero_path) else 5
		if _needs_9_skills(hero_path):
			any_a = true
		
		# Validate skills array
		if typeof(slot_data["skills"]) != TYPE_ARRAY:
			return false
		var skills: Array[int] = []
		skills.assign(slot_data["skills"])
		if skills.size() != count:
			return false

		# Skills must be 0..10 and unique (no repeats)
		var used_skills: Array[int] = []
		for i in skills.size():
			var skill := skills[i]
			if skill < 0 or skill > 10:
				if count == 5 and i < 5:
					return false
			if used_skills.has(skill):
				return false
			used_skills.append(skill)
		
		# Expected code length: 1 for hero + 3 (5 skills) or 6 (9 skills)
		expected_len += 1 + (6 if count == 9 else 3)
	
	# Your additional assumption: at most one A* hero
	if any_a:
		var a_count := 0
		for slot in ["1", "2", "3", "4"]:
			var hero_path := out[slot]["hero_path"] as Data.HeroesPaths
			if _needs_9_skills(hero_path):
				a_count += 1
		if a_count > 1:
			return false
	
	# Validate the encoded part length (reject random strings)
	# Must match exactly, not "less or equal", otherwise random strings still parse.
	if code_length != expected_len:
		return false
	
	return true
