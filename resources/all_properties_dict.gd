class_name AllPropertiesDictionary
extends Resource

const NBSP := "\u00A0"

var properties: Dictionary[String, String] = {}
var path_comments: Dictionary[HeroesPaths.Enum, PackedStringArray] = {}


static func create(props_json_string: String, path_comments_json_string: String) -> AllPropertiesDictionary:
	var all_props := AllPropertiesDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(props_json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in props_json_string at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_props.properties.assign(data)
	
	assert(not all_props.properties.is_empty())
	for key in all_props.properties.keys():
		all_props.properties[key] = all_props.properties[key].replace(" ", NBSP)

	parse_result = json.parse(path_comments_json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in path_comments_json_string at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			var converted_data := {}
			for key in data.keys():
				var hero_path := HeroesPaths.from_text(key)
				assert(hero_path != HeroesPaths.Enum.NONE)
				var array := PackedStringArray(data[key])
				converted_data[hero_path] = array
			all_props.path_comments.assign(converted_data)

	return all_props


func construct_text(tokens: Array[String], is_4rank: bool) -> String:
	var sentence := ""
	for token in tokens:
		var texts := check_and_convert_texts_to_icons(properties[token], NBSP)
		if token in Data.RANKS_TOKENS:
			if not is_4rank:
				texts.remove_at(texts.size() - 1)
				texts.remove_at(texts.size() - 1)
				sentence += NBSP.join(texts)
			else:
				sentence += NBSP.join(texts) + tokens[1] # tokens[1] = "N heroes"
			break
		else:
			sentence += NBSP.join(texts)
	
	return sentence.strip_edges()


static func check_and_convert_texts_to_icons(line: String, splitter: String) -> PackedStringArray:
	var texts := line.split(splitter)
	for i in texts.size():
		if texts[i].begins_with("$"):
			texts[i] = "[img]" + Data.all_icons.get_texture_path(texts[i]) + "[/img]"
	return texts
