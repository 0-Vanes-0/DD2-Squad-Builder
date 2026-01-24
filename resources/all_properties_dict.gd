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


func construct_text(in_label: RichTextLabel, tokens: Array[String], is_4rank: bool):
	for token in tokens:
		split_and_convert_texts_to_icons(in_label, properties[token])
		if token in Data.RANKS_TOKENS:
			if is_4rank:
				in_label.append_text(tokens[1]) # tokens[1] = " by N heroes"
			break


func append_path_comment(in_label: RichTextLabel, hero_path: HeroesPaths.Enum, include_a := false) -> bool:
	var path_comment := path_comments.get(hero_path, PackedStringArray()) as PackedStringArray
	if not path_comment.is_empty():
		for comment in path_comment:
			split_and_convert_texts_to_icons(in_label, comment, include_a)
			
		in_label.append_text("\n")
	
	return not path_comment.is_empty()


static func split_and_convert_texts_to_icons(in_label: RichTextLabel, line: String, include_a := false):
	var texts := line.split(" ")
	if line.begins_with("@"):
		if include_a:
			in_label.append_text("Wanderer diff:")
			for i in range(1, texts.size()):
				var hero := texts[i].substr(1, 1)
				var skill := int(texts[i].substr(2))
				in_label.add_image(Data.skills_textures[hero].skills[skill], 50, 50)
	else:
		for i in texts.size():
			if texts[i].begins_with("$"):
				var texture := Data.all_icons.get_texture(texts[i]) as Texture2D
				if texture != null:
					in_label.add_image(texture)
			elif texts[i].begins_with("#"):
				var hero := texts[i].substr(1, 1)
				var skill := int(texts[i].substr(2))
				in_label.add_image(Data.skills_textures[hero].skills[skill], 50, 50)
			else:
				texts[i] = texts[i].replace(" ", NBSP)
				in_label.append_text(texts[i])
				if i+1 < texts.size() and not texts[i+1].begins_with("#"):
					in_label.append_text(NBSP)
			
