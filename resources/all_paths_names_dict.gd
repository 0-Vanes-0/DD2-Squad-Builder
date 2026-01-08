class_name AllPathsNamesDictionary
extends Resource

const NBSP := "\u00A0"

var dict: Dictionary[HeroesPaths.Enum, String] = {}


static func create(all_paths_names_json_string: String) -> AllPathsNamesDictionary:
	var all_paths_names := AllPathsNamesDictionary.new()
	var json = JSON.new()
	var parse_result: Error = json.parse(all_paths_names_json_string)
	if parse_result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in all_paths_names_json_string at line ", json.get_error_line())
	else:
		var data = json.data
		if data is Dictionary:
			for key in data.keys():
				var hero_path := HeroesPaths.from_text(key)
				all_paths_names.dict[hero_path] = data[key]
	return all_paths_names


func get_path_name(hero_path: HeroesPaths.Enum) -> String:
	if dict.has(hero_path):
		return dict[hero_path]
	return ""
