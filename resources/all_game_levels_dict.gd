class_name AllGameLevelsDictionary
extends Resource

var dict: Dictionary[String, PackedStringArray] = {}


static func create(json_text: String) -> AllGameLevelsDictionary:
	var all_game_levels := AllGameLevelsDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(json_text)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in acts_json_text at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_game_levels.dict.assign(data)
	
	assert(not all_game_levels.dict.is_empty())
	return all_game_levels


func assign_game_level(in_label: RichTextLabel, game_level: GameLevelDraggable.GameLevels):
	if game_level == GameLevelDraggable.GameLevels.NONE:
		return
	
	var game_level_texts := dict[_game_level_to_text(game_level)]
	var is_table_now := false
	for i in game_level_texts.size():
		if i == 0:
			in_label.push_font(Data.dd_2_font, 32)
			in_label.append_text(game_level_texts[0])
			in_label.pop()
			in_label.newline()
			continue
		
		var line := game_level_texts[i]
		if line == "?":
			in_label.push_table(3)
			is_table_now = true
			continue
		
		if line == "¿":
			in_label.pop()
			is_table_now = false
			continue
		
		if is_table_now:
			in_label.push_cell()
			var padding := 10
			in_label.set_cell_padding(Rect2(padding, padding, padding, padding))
		
		AllPropertiesDictionary.split_and_convert_texts_to_icons(in_label, line)
			
		if is_table_now:
			in_label.pop()
		else:
			in_label.newline()


func _game_level_to_text(game_level: GameLevelDraggable.GameLevels) -> String:
	return GameLevelDraggable.GameLevels.keys()[game_level] as String
