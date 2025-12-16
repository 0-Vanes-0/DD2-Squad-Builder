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
		assert(skills.size() == count)

		for skill in skills:
			if skill == -1:
				return ""
			assert(skill >= 0 and skill <= 10)

		var packed := _skills_to_int(skills)
		var skill_len := 6 if count == 9 else 3
		code += _b64_encode_fixed(packed, skill_len)

	# Keep squad_name readable, but make it safe for the delimiter.
	# (If you truly want it raw, you must forbid '|' in names.)
	var name := String(data.get("squad_name", ""))
	return code + "|" + name.uri_encode()


static func decode_squad(text: String) -> Dictionary:
	var pipe_index := text.find("|")
	var code := text if pipe_index == -1 else text.substr(0, pipe_index)
	var name := "" if pipe_index == -1 else text.substr(pipe_index + 1).uri_decode()

	var out: Dictionary = { "squad_name": name }

	var index := 0
	for slot in [1, 2, 3, 4]:
		assert(index < code.length())
		var hero_path := _b64_value(code[index])
		index += 1

		var count := 9 if _needs_9_skills(hero_path) else 5
		var skill_len := 6 if count == 9 else 3

		assert(index + skill_len <= code.length())
		var skills_text := code.substr(index, skill_len)
		index += skill_len

		var packed := _b64_decode_fixed(skills_text)
		var skills := _int_to_skills(packed, count)

		out[slot] = {
			"hero_path": hero_path,
			"skills": skills
		}

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
