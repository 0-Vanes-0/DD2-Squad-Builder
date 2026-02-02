class_name AllFlamesDictionary
extends Resource

var dict: Dictionary[String, PackedStringArray] = {}


static func create(json_text: String) -> AllFlamesDictionary:
	var all_flames := AllFlamesDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(json_text)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in props_json_string at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_flames.dict.assign(data)
	
	assert(not all_flames.dict.is_empty())
	return all_flames


func assign_flame(in_label: RichTextLabel, flame: FlameDraggable.Flames):
	if flame == FlameDraggable.Flames.NONE:
		return
	
	var flame_texts := dict[_flame_to_text(flame)]
	var is_table_now := false
	for i in flame_texts.size():
		if i == 0:
			in_label.push_font_size(32)
			in_label.append_text(flame_texts[0])
			in_label.pop()
			in_label.newline()
			continue
		
		var line := flame_texts[i]
		if line == "?":
			in_label.newline()
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


func _flame_to_text(flame: FlameDraggable.Flames) -> String:
	return FlameDraggable.Flames.keys()[flame] as String
