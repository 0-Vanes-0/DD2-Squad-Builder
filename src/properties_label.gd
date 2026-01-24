class_name PropertiesLabel
extends RichTextLabel

const NBSP := "\u00A0"
const FIRST_WORDS := [
	"apply_dot", "apply_hero", "apply_enemy",
	"remove_dot", "remove_enemy", "remove_hero",
	"consume_hero", "consume_enemy", "ignore",
	"steal_hero", "steal_enemy",
	"convert_from_bleed", "convert_from_blight", "convert_from_burn", "convert_from_dot",
	"move_forw", "move_back", "move_enemy",
	"clear", "heal", "calm", "execute", "extra", "aoe", "invert_hero", "invert_enemy", "cooldown",
	"selfdmg", "stack",
]

@export var does_belong_to_hero := false


func update_skills_props(ranks: Array[String] = ["1", "2", "3", "4"]):
	self.clear()
	var tokens_map := {}
	
	for rank in ranks:
		var rank_flags: Dictionary[String, bool] = {}
		for rank_token in Data.RANKS_TOKENS:
			rank_flags[rank_token] = false
		
		var hero_path := Data.current_squad[rank]["hero_path"] as HeroesPaths.Enum
		var skills: Array[int]
		skills.assign(Data.current_squad[rank]["skills"])
		
		for number in skills:
			var tokens := Data.all_heroes_skills_properties.get_tokens(hero_path, number)
			if not tokens.is_empty():
				for token in tokens:
					var words := token.split(" ", false) # 'false' is to prevent accident 2 spaces.
					if not words[0] in FIRST_WORDS:
						print_debug("Heropath %s, skill %s has bad properties: %s" % [HeroesPaths.to_text(hero_path), number, tokens])
					else:
						if words.size() == 1:
							if not rank_flags.has(words[0]):
								_add_to_tokens_map(tokens_map, words[0])
							elif rank_flags[words[0]] == false:
								rank_flags[words[0]] = true
								_add_to_tokens_map(tokens_map, words[0], ["-"])
						else:
							_add_to_tokens_map(tokens_map, words[0], words.slice(1))
	
	var is_4ranks := ranks.size() == 4

	var has_text := false
	self.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER) # [center]
	if not is_4ranks:
		var label_rank := ranks[0]
		has_text = Data.all_props.append_path_comment(self, Data.current_squad[label_rank]["hero_path"])
	
	var sorted_tokens_map := _get_sorted_tokens_map(tokens_map)
	var empty := [""]
	for first_word in sorted_tokens_map.keys():
		var tokens: Array[String]
		if first_word in Data.RANKS_TOKENS:
			if is_4ranks:
				var amount := sorted_tokens_map[first_word].size() as int
				var heroes := NBSP + "heroes" if amount > 1 else NBSP + "hero"
				tokens.assign([NBSP + "by" + NBSP + str(amount) + heroes])
		elif sorted_tokens_map[first_word][0] != empty[0]:
			tokens.assign(sorted_tokens_map[first_word])
		
		tokens.push_front(first_word)
		Data.all_props.construct_text(self, tokens, is_4ranks)
		self.append_text(". " if is_4ranks else "\n")
		has_text = true
	
	if not has_text:
		self.append_text("No info yet.")
	
	self.pop() # [/center]


func _add_to_tokens_map(tokens_map: Dictionary, first_word: String, args := [""]):
	if not tokens_map.has(first_word):
		tokens_map[first_word] = []
	
	for word in args:
		if not word in tokens_map[first_word] or first_word in Data.RANKS_TOKENS:
			tokens_map[first_word].append(word)


## Returns [param dict] sorted in order of [member FIRST_WORDS].
func _get_sorted_tokens_map(dict: Dictionary) -> Dictionary:
	var sorted_tokens_map := {}
	for word in FIRST_WORDS:
		if dict.has(word):
			sorted_tokens_map[word] = dict[word]
	return sorted_tokens_map
