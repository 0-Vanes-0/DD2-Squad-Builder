class_name PropertiesLabel
extends RichTextLabel

const FIRST_WORDS := [
	"apply_dot", "apply_pos", "apply_neg", "apply",
	"remove_dot", "remove_pos", "remove_neg", "remove",
	"consume", "ignore",
	"convert_from_bleed", "convert_from_blight", "convert_from_burn", "convert_from_dot",
	"move_ally", "move_enemy",
	"clear", "heal",
]
var tokens_map := {}


func update_skills_props():
	self.clear()
	tokens_map.clear()
	
	for rank in ["1", "2", "3", "4"]:
		var has_rank_healing := false
		var hero_path := Data.current_squad[rank]["hero_path"] as HeroesPaths.Enum
		
		var skills: Array[int]
		skills.assign(Data.current_squad[rank]["skills"])
		for number in skills:
			var tokens := Data.all_heroes_skills_properties.get_tokens(hero_path, number)
			if not tokens.is_empty():
				for token in tokens:
					var words := token.split(" ", false)
					if words[0] in FIRST_WORDS:
						if words.size() == 1:
							if words[0] == "heal":
								if not has_rank_healing:
									_add_to_tokens_map(words[0], ["1"])
									has_rank_healing = true
							else:
								_add_to_tokens_map(words[0])
						else:
							_add_to_tokens_map(words[0], words.slice(1))
					else:
						print_debug("Heropath %s, skill %s has bad properties: %s" % [HeroesPaths.to_text(hero_path), number, tokens])
	
	
	var sorted_tokens_map := _get_sorted_tokens_map(tokens_map)
	var full_text := ""
	var empty := [""]
	for first_word in sorted_tokens_map.keys():
		var tokens: Array[String]
		if first_word == "heal":
			var amount := sorted_tokens_map[first_word].size() as int
			var heroes := " heroes." if amount > 1 else " hero."
			tokens.assign([str(amount) + heroes])
		elif sorted_tokens_map[first_word][0] != empty[0]:
			tokens.assign(sorted_tokens_map[first_word])
		
		tokens.push_front(first_word)
		full_text += Data.all_props.construct_text(tokens) + " "
	
	if full_text.is_empty():
		full_text = "No squad info yet."
	
	self.append_text("[center]")
	self.append_text(full_text.strip_edges())
	self.append_text("[/center]")


func _add_to_tokens_map(first_word: String, args := [""]):
	if not tokens_map.has(first_word):
		tokens_map[first_word] = []
	
	for word in args:
		if not word in tokens_map[first_word] or first_word == "heal":
			tokens_map[first_word].append(word)


func _get_sorted_tokens_map(dict: Dictionary) -> Dictionary:
	var sorted_tokens_map := {}
	for word in FIRST_WORDS:
		if dict.has(word):
			sorted_tokens_map[word] = dict[word]
	return sorted_tokens_map
