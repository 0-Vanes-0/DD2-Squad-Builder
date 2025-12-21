class_name AllPropertiesDictionary
extends Resource

const NBSP := "\u00A0"

@export var properties: Dictionary[String, String] = {}


static func create(json_string: String) -> AllPropertiesDictionary:
	var all_props := AllPropertiesDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			all_props.properties.assign(data)
	
	assert(not all_props.properties.is_empty())
	for key in all_props.properties.keys():
		all_props.properties[key] = all_props.properties[key].replace(" ", NBSP)
	return all_props


func construct_text(tokens: Array[String]) -> String:
	var sentence := ""
	for token in tokens:
		if token in PropertiesLabel.RANKS_TOKENS:
			sentence += properties[token] + tokens[1]
			break
		
		var text := properties[token]
		if text.begins_with("$"): # TODO: make better $ replacement
			text = "[img]" + Data.all_icons.get_texture_path(text) + "[/img]"
		sentence += text
	return sentence.strip_edges()
