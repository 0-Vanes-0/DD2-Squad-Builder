class_name CoachMenu
extends MarginContainer

enum Options {
	Random_Heroes = 0,
	Random_Heroes_and_Paths = 1,
	Mystery_skills = 2,
	Random_skills = 3,
	Random_pet = 4,
	Random_flame = 5,
	Random_act = 6,
}

const MYSTERY_SKILLS := {
	"P": [
		[0, 3, 2, 1, 4],
		[0, 3, 2, 7, 9],
		[0, 3, 5, 1, 9],
		[0, 3, 5, 7, 4],
	],
	"G": [
		[0, 1, 4, 10, 3],
		[0, 1, 4, 5, 2],
		[0, 1, 9, 10, 2],
		[0, 1, 9, 5, 3],
	],
	"W": [
		[0, 3, 1, 10, 2],
		[0, 3, 1, 8, 7],
		[0, 3, 6, 10, 2],
		[0, 3, 6, 8, 7],
	],
	"M": [
		[0, 2, 5, 6, 1],
		[0, 2, 5, 10, 4],
		[0, 2, 7, 10, 1],
		[0, 2, 7, 6, 4],
	],
	"H": [
		[0, 3, 2, 4, 5],
		[0, 3, 2, 1, 7],
		[0, 3, 8, 1, 5],
		[0, 3, 8, 4, 7],
	],
	"J": [
		[0, 4, 2, 3, 1],
		[0, 4, 2, 8, 10],
		[0, 4, 5, 3, 1],
		[0, 4, 5, 8, 10],
	],
	"L": [
		[0, 4, 2, 1, 9],
		[0, 4, 2, 7, 10],
		[0, 4, 3, 1, 9],
		[0, 4, 3, 7, 10],
	],
	"O": [
		[0, 3, 2, 1, 7],
		[0, 3, 2, 6, 8],
		[0, 3, 5, 1, 8],
		[0, 3, 5, 6, 7],
	],
	"R": [
		[0, 1, 6, 5, 4],
		[0, 1, 6, 10, 9],
		[0, 1, 3, 5, 9],
		[0, 1, 3, 10, 4],
	],
	"V": [
		[0, 3, 6, 1, 8],
		[0, 3, 6, 7, 4],
		[0, 3, 2, 7, 8],
		[0, 3, 2, 1, 4],
	],
	"F": [
		[0, 4, 2, 1, 3],
		[0, 4, 9, 1, 7],
		[0, 4, 9, 5, 3],
		[0, 4, 2, 5, 7],
	],
	"D": [
		[0, 1, 3, 5, 4],
		[0, 1, 3, 9, 8],
		[0, 1, 2, 9, 4],
		[0, 1, 2, 5, 7],
	],
	"C": [
		[0, 4, 2, 1, 7],
		[0, 4, 2, 6, 10],
		[0, 4, 5, 6, 7],
		[0, 4, 5, 1, 10],
	],
	"A": [
		[1, 2, 3, 4, 5, 7, 8, 9, 10],
		[0, 2, 3, 4, 5, 6, 8, 9, 10],
		[0, 1, 3, 4, 5, 6, 7, 9, 10],
		[0, 1, 2, 4, 5, 6, 7, 8, 10],
	],
	"B": [
		[0, 1, 2, 4, 5],
		[0, 1, 2, 3, 10],
		[0, 1, 9, 4, 10],
		[0, 1, 9, 3, 5],
	],
}

@export var main_scene: MainScene
@export_group("Required Children")
@export var flames_grid: GridContainer
@export var acts_grid: GridContainer
@export var pets_grid: GridContainer
@export var randomize_option_button: OptionButton
@export var randomize_button: Button



func _ready() -> void:
	for node in flames_grid.get_children():
		node.queue_free()
	for node in acts_grid.get_children():
		node.queue_free()
	for node in pets_grid.get_children():
		node.queue_free()
	
	for value in FlameDraggable.Flames.values():
		if value == FlameDraggable.Flames.NONE:
			continue
		
		var flame_draggable := FlameDraggable.create(value)
		flame_draggable.info_requested.connect(
				func(main_value: Variant):
					if main_value == FlameDraggable.Flames.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_flame(main_value)
		)
		flames_grid.add_child(flame_draggable)
	
	for value in GameLevelDraggable.GameLevels.values():
		if value == GameLevelDraggable.GameLevels.NONE:
			continue
		
		if value == GameLevelDraggable.GameLevels.KINGDOM_BEAST:
			acts_grid.add_child(Control.new())
			
		var game_level_draggable := GameLevelDraggable.create(value)
		game_level_draggable.info_requested.connect(
				func(main_value: Variant):
					if main_value == GameLevelDraggable.GameLevels.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_game_level(main_value)
		)
		acts_grid.add_child(game_level_draggable)
	
	for value in PetDraggable.Pets.values():
		if value == PetDraggable.Pets.NONE:
			continue
		
		var pet_draggable := PetDraggable.create(value)
		pet_draggable.info_requested.connect(
				func(main_value: Variant):
					if main_value == PetDraggable.Pets.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_pet(main_value)
		)
		pets_grid.add_child(pet_draggable)


func _on_randomize_button_pressed() -> void:
	match randomize_option_button.selected:
		Options.Random_Heroes:
			var heroes: Array[HeroesPaths.Enum] = []
			for hero in range(1, HeroesPaths.Enum.keys().size() - 1, 4):
				heroes.append(hero)
			
			heroes.shuffle()
			heroes.resize(4)
			for i in main_scene.rank_boxes.values().size():
				var rank_box := main_scene.rank_boxes.values()[i] as RankBox
				rank_box.hero_path_draggable.set_hero_path(heroes[i])
				rank_box.set_skills(Data.get_empty_skills(), heroes[i])
		
		Options.Random_Heroes_and_Paths:
			var heroes: Array[HeroesPaths.Enum] = []
			for hero in range(1, HeroesPaths.Enum.keys().size() - 1, 4):
				heroes.append(hero + randi_range(0, 3))
			
			heroes.shuffle()
			heroes.resize(4)
			for i in main_scene.rank_boxes.values().size():
				var rank_box := main_scene.rank_boxes.values()[i] as RankBox
				rank_box.hero_path_draggable.set_hero_path(heroes[i])
				rank_box.set_skills(Data.get_empty_skills(), heroes[i])
		
		Options.Mystery_skills:
			if main_scene.rank_boxes.values().any(
					func(box: RankBox): return box.hero_path_draggable.get_hero_path() == HeroesPaths.Enum.NONE
			):
				main_scene.notification_panel.show_message("Assign/randomize heroes first!")
			else:
				for i in main_scene.rank_boxes.values().size():
					var rank_box := main_scene.rank_boxes.values()[i] as RankBox
					var hero_path := rank_box.hero_path_draggable.get_hero_path()
					var hero := HeroesPaths.to_hero(hero_path)
					var skills: Array[int] = []
					skills.assign((MYSTERY_SKILLS[hero] as Array).pick_random())
					
					rank_box.set_skills(skills, hero_path)
		
		Options.Random_skills:
			if main_scene.rank_boxes.values().any(
					func(box: RankBox): return box.hero_path_draggable.get_hero_path() == HeroesPaths.Enum.NONE
			):
				main_scene.notification_panel.show_message("Assign/randomize heroes first!")
			else:
				for i in main_scene.rank_boxes.values().size():
					var rank_box := main_scene.rank_boxes.values()[i] as RankBox
					var hero_path := rank_box.hero_path_draggable.get_hero_path()
					var skills: Array[int] = []
					skills.assign(range(0, 11))
					if HeroesPaths.is_abomination(hero_path):
						skills.erase(randi_range(0, 4))
						skills.erase(randi_range(6, 10))
					else:
						skills.shuffle()
						skills.resize(5)
					
					rank_box.set_skills(skills, hero_path)
		
		Options.Random_pet:
			var pets := PetDraggable.Pets.values()
			pets.pop_front() # NONE
			main_scene.pet_draggable.set_pet(pets.pick_random())
		
		Options.Random_flame:
			var flames := FlameDraggable.Flames.values()
			flames.pop_front() # NONE
			main_scene.flame_draggable.set_flame(flames.pick_random())
		
		Options.Random_act:
			var acts := GameLevelDraggable.GameLevels.values()
			acts.pop_front() # NONE
			acts.resize(5)
			main_scene.game_level_draggable.set_game_level(acts.pick_random())
	
	main_scene.update_heroes_in_data()
