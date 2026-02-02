class_name AllActsDictionary
extends Resource

var dict: Dictionary[String, PackedStringArray] = {}


static func create(json_text: String) -> AllActsDictionary:
	var all_acts := AllActsDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(json_text)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in acts_json_text at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_acts.dict.assign(data)
	
	assert(not all_acts.dict.is_empty())
	return all_acts


func assign_act(in_label: RichTextLabel, act: ActDraggable.Acts):
	if act == ActDraggable.Acts.NONE:
		return
	
	var act_texts := dict[_act_to_text(act)]
	var is_table_now := false
	for i in act_texts.size():
		if i == 0:
			in_label.push_font_size(32)
			in_label.append_text(act_texts[0])
			in_label.pop()
			in_label.newline()
			continue
		
		var line := act_texts[i]
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


func _act_to_text(act: ActDraggable.Acts) -> String:
	return ActDraggable.Acts.keys()[act] as String
