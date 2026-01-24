class_name AllSkillsCommentsDictionary
extends Resource

var dict: Dictionary[String, Dictionary] = {}
var viewport: RankSubviewport


static func create(json_text: String) -> AllSkillsCommentsDictionary:
	var all_skills_comments := AllSkillsCommentsDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(json_text)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in props_json_string at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_skills_comments.dict.assign(data)
	
	assert(not all_skills_comments.dict.is_empty())
	
	return all_skills_comments


func assign_comments(in_label: RichTextLabel, hero_path: HeroesPaths.Enum, skill_number: int):
	if viewport == null:
		print_debug("AllSkillsCommentsDictionary: RankSubviewport is not assigned!")
		return

	var skill_types_icons: Dictionary[String, Texture2D] = {
		"melee": Data.all_icons.get_texture("$tml"),
		"ranged": Data.all_icons.get_texture("$trg"),
		"heal": Data.all_icons.get_texture("$thl"),
		"stress": Data.all_icons.get_texture("$tst"),
	}
	var key := "%s_%d" % [HeroesPaths.to_text(hero_path), skill_number]
	var skill_data := dict.get(key, {}) as Dictionary
	if not skill_data.is_empty():
		var image := Data.get_skill_texture(hero_path, skill_number) as Texture2D
		in_label.add_image(image, 100, 100)
		in_label.append_text("[font_size=32]%s[/font_size]\n" % skill_data["name"])

		if skill_data["type"] != "-":
			in_label.append_text("                    ")
			in_label.add_image(skill_types_icons[skill_data["type"]])
			in_label.append_text(" %s\n" % (skill_data["type"] as String).to_pascal_case())

		var self_ranks := await viewport.get_image(skill_data["skill_ranks"], true)
		in_label.add_image(self_ranks, RankSubviewport.IN_TEXT_SIZE.x, RankSubviewport.IN_TEXT_SIZE.y)
		in_label.append_text("  [font_size=32]→[/font_size]  ")
		if skill_data["target_ranks"] == "self":
			in_label.append_text("Self")
		else:
			var target_ranks := await viewport.get_image(skill_data["target_ranks"], skill_data["target_type"] != "enemy")
			in_label.add_image(target_ranks, RankSubviewport.IN_TEXT_SIZE.x, RankSubviewport.IN_TEXT_SIZE.y)
			if skill_data["target_type"] == "ally":
				in_label.append_text(" (not Self)")
		
		in_label.append_text("\n")

		if skill_data["cooldown"] != "-":
			var cooldown := skill_data["cooldown"] as String
			var parenthesis_index := cooldown.find("(")
			if parenthesis_index != -1:
				in_label.append_text("Cooldown: " + cooldown.substr(0, parenthesis_index + 1))
				in_label.add_image(Data.all_icons.get_texture("$upg"))
				in_label.append_text(cooldown.substr(parenthesis_index + 1))
			else:
				in_label.append_text("Cooldown: " + skill_data["cooldown"])
			in_label.append_text("    ")
		
		if skill_data["uses"] != "-":
			var uses := skill_data["uses"] as String
			var parenthesis_index := uses.find("(")
			if parenthesis_index != -1:
				in_label.append_text("Uses: " + uses.substr(0, parenthesis_index + 1))
				in_label.add_image(Data.all_icons.get_texture("$upg"))
				in_label.append_text(uses.substr(parenthesis_index + 1))
			else:
				in_label.append_text("Uses: " + skill_data["uses"])
		
		if skill_data["cooldown"] != "-" or skill_data["uses"] != "-":
			in_label.append_text("\n\n")
		
		var skill_text: Array[String]
		skill_text.assign(skill_data["skill_text"])
		for line in skill_text:
			AllPropertiesDictionary.split_and_convert_texts_to_icons(in_label, line)
			in_label.append_text("\n")
		
		in_label.append_text("-------------------------")
		in_label.add_image(Data.all_icons.get_texture("$upg"))
		in_label.append_text("Upgraded -------------------------\n")

		var skill_u_text: Array[String]
		skill_u_text.assign(skill_data["skill_u_text"])
		for line in skill_u_text:
			AllPropertiesDictionary.split_and_convert_texts_to_icons(in_label, line)
			in_label.append_text("\n")

	else:
		in_label.append_text("No information available.")
