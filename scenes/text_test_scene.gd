extends Control

@export_group("Required Children")
@export var label: RichTextLabel
@export var viewport: RankSubviewport

var test_dict: Dictionary[String, Dictionary] = {
	"J3_4": {
		"name": "Inspiring Tune",
		"type": "stress",
		"skill_ranks": "12",
		"target_ranks": "1234-",
		"target_type": "hero",
		"cooldown": "2",
		"uses": "-",
		"skill_text": [
			"Requires targets $sts 5+ :",
			"-1 $sts when target $sts 5+",
			"-1 $sts when target $bld",
			"$bld 1",
		],
		"skill_u_text": [
			"Requires targets $sts 5+ or targets $bld :",
			"-1 $sts when target $sts 5+",
			"-1 $sts when target $bld",
			"$bld 1",
		],
	},
	"L1_0": {
		"name": "Chop",
		"type": "melee",
		"skill_ranks": "12",
		"target_ranks": "12",
		"target_type": "enemy",
		"cooldown": "-",
		"uses": "-",
		"skill_text": [
			"DMG: 6-12",
			"CRIT: 5%",
			"Ignores $bln $vvk when target $cmb",
			"+10% DMG per $neg on self",
			"Self: $bln , 2 DMG per $neg on self to a maximum of 10 DMG",
		],
		"skill_u_text": [
			"DMG: 6-12",
			"CRIT: 5%",
			"Ignores $bln $vvk when target $cmb",
			"+15% DMG per $neg on self",
			"Self: $bln (75%), 2 DMG per $neg on self to a maximum of 10 DMG",
		],
	},
	"H0_7": {
		"name": "Bloodlust",
		"type": "-",
		"skill_ranks": "123",
		"target_ranks": "self",
		"target_type": "hero",
		"cooldown": "2",
		"uses": "-",
		"skill_text": [
			"Requires $wnd",
			"Removes $wnd",
			"$wnd x1: $fst",
			"$wnd x2: $str",
			"$wnd x3: $crt",
		],
		"skill_u_text": [
			"Requires $wnd",
			"Removes $wnd",
			"$wnd x1: $fst",
			"$wnd x2: $str",
			"$wnd x3: $crt",
			"Melee skills: $exe 2 (3 turns)",
		],
	},
	"D0_6": {
		"name": "Again",
		"type": "-",
		"skill_ranks": "1234",
		"target_ranks": "1234",
		"target_type": "ally",
		"cooldown": "5",
		"uses": "2",
		"skill_text": [
			"Target: Clear Skills Cooldowns",
			"Requires $agr",
			"Remove $agr $def",
		],
		"skill_u_text": [
			"Target: Clear Skills Cooldowns",
			"Requires $agr or $def",
		],
	},
	"C3_6": {
		"name": "Battle Heal",
		"type": "heal",
		"skill_ranks": "1234",
		"target_ranks": "1234",
		"target_type": "hero",
		"cooldown": "2(1)",
		"uses": "4",
		"skill_text": [
			"Requires $hlh < 50%",
			"Heal 20%",
		],
		"skill_u_text": [
			"Requires $hlh < 50%",
			"Heal 30%",
		],
	}
}


func _ready() -> void:
	assert(label and viewport)
	var skill_types_icons: Dictionary[String, Texture2D] = {
		"melee": Data.all_icons.get_texture("$tml"),
		"ranged": Data.all_icons.get_texture("$trg"),
		"heal": Data.all_icons.get_texture("$thl"),
		"stress": Data.all_icons.get_texture("$tst"),
	}
	
	for hero_path_skill in test_dict:
		var value := test_dict[hero_path_skill]
		if hero_path_skill.length() in [4, 5]:
			var splitted := hero_path_skill.split("_")
			var hero_path := HeroesPaths.from_text(splitted[0])
			var skill := int(splitted[1])
			var image := Data.get_skill_texture(hero_path, skill)
			label.add_image(image, 100, 100)
			label.append_text("[font_size=32]%s[/font_size]\n" % value["name"])
			
			if value["type"] != "-":
				label.append_text("                    ")
				label.add_image(skill_types_icons[value["type"]])
				label.append_text(" %s\n" % (value["type"] as String).to_pascal_case())
			
			var self_ranks := await viewport.get_image(value["skill_ranks"], true)
			label.add_image(self_ranks, RankSubviewport.IN_TEXT_SIZE.x, RankSubviewport.IN_TEXT_SIZE.y)
			label.append_text("  [font_size=32]→[/font_size]  ")
			if value["target_ranks"] == "self":
				label.append_text("Self")
			else:
				var target_ranks := await viewport.get_image(value["target_ranks"], value["target_type"] != "enemy")
				label.add_image(target_ranks, RankSubviewport.IN_TEXT_SIZE.x, RankSubviewport.IN_TEXT_SIZE.y)
				if value["target_type"] == "ally":
					label.append_text(" (not Self)")
			
			label.append_text("\n")
			
			if value["cooldown"] != "-":
				var cooldown := value["cooldown"] as String
				var parenthesis_index := cooldown.find("(")
				if parenthesis_index != -1:
					label.append_text("Cooldown: " + cooldown.substr(0, parenthesis_index + 1))
					label.add_image(Data.all_icons.get_texture("$upg"))
					label.append_text(cooldown.substr(parenthesis_index + 1))
				else:
					label.append_text("Cooldown: " + value["cooldown"])
				label.append_text("    ")
			
			if value["uses"] != "-":
				var uses := value["uses"] as String
				var parenthesis_index := uses.find("(")
				if parenthesis_index != -1:
					label.append_text("Uses: " + uses.substr(0, parenthesis_index + 1))
					label.add_image(Data.all_icons.get_texture("$upg"))
					label.append_text(uses.substr(parenthesis_index + 1))
				else:
					label.append_text("Uses: " + value["uses"])
			
			if value["cooldown"] != "-" or value["uses"] != "-":
				label.append_text("\n\n")
			
			var skill_text: Array[String]
			skill_text.assign(value["skill_text"])
			for line in skill_text:
				AllPropertiesDictionary.split_and_convert_texts_to_icons(label, line)
				label.append_text("\n")
			
			label.append_text("-------------------------")
			label.add_image(Data.all_icons.get_texture("$upg"))
			label.append_text("Upgraded -------------------------\n")

			var skill_u_text: Array[String]
			skill_u_text.assign(value["skill_u_text"])
			for line in skill_u_text:
				AllPropertiesDictionary.split_and_convert_texts_to_icons(label, line)
				label.append_text("\n")
		
		label.append_text("\n\n")
