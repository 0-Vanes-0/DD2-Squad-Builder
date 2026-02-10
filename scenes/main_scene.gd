class_name MainScene
extends Control

@export_group("Required Chilren")
@export var tab_bar: MenuTabBar
@export var tab_container: TabContainer
@export var split_container: HSplitContainer
@export var rank_boxes: Dictionary[int, RankBox] = {
	1: null,
	2: null,
	3: null,
	4: null,
}
@export var flame_draggable: FlameDraggable
@export var game_level_draggable: GameLevelDraggable
@export var pet_draggable: PetDraggable
@export var bottom_box: BottomBox
@export var skills_menu: SkillsMenu
@export var saved_squads_menu: SavedSquadsMenu
@export var notification_panel: NotificationPanel
@export var popup_panel: MyPopupPanel
@export var viewport: RankSubviewport


func _ready() -> void:
	assert(tab_bar and tab_container and split_container and popup_panel and bottom_box and skills_menu and notification_panel and popup_panel and viewport)
	randomize()
	for rank_box in rank_boxes.values():
		assert(rank_box)
	tab_bar.current_tab = 0
	tab_container.current_tab = 0
	$HSplitContainer/RightVBox/TabContainer/Info/ScrollContainer.scroll_vertical = 0
	
	for rank_box: RankBox in rank_boxes.values():
		rank_box.hero_path_draggable.is_unique = (
				func(hero_path: HeroesPaths.Enum) -> bool:
					var hero := HeroesPaths.to_hero(hero_path)
					var rank_box_hero := HeroesPaths.to_hero(rank_box.hero_path_draggable.get_hero_path())
					return hero == rank_box_hero or rank_boxes.values().all(
							func(rb: RankBox) -> bool:
								var rb_hero := HeroesPaths.to_hero(rb.hero_path_draggable.get_hero_path())
								return hero != rb_hero 
					)
		)
		rank_box.hero_path_draggable.info_requested.connect(
				func(data: Variant):
					if data == HeroesPaths.Enum.NONE:
						notification_panel.hide()
					else:
						notification_panel.show_hero_path(data)
		)
		rank_box.hero_path_draggable.item_dropped.connect(
				func(drop_info: Variant):
					# NOTE: Hero paths are already changed!!!
					
					assert(drop_info != null)
					var from_rank := int(drop_info)
					# If dropped from another rank box:
					if from_rank > 0:
						if from_rank != rank_box.rank:
							var from_rank_box := rank_boxes[from_rank]
							var temp_skills := rank_boxes[from_rank].get_skills()
							from_rank_box.set_skills(rank_box.get_skills(), from_rank_box.hero_path_draggable.get_hero_path())
							rank_box.set_skills(temp_skills, rank_box.hero_path_draggable.get_hero_path())
					
					# If dropped from heroes table:
					else:
						var hero_path_from_data := Data.current_squad[str(rank_box.rank)]["hero_path"] as HeroesPaths.Enum
						var hero_path_dropped := rank_box.hero_path_draggable.get_hero_path() as HeroesPaths.Enum
						var hero_from_data := HeroesPaths.to_hero(hero_path_from_data)
						var hero_dropped := HeroesPaths.to_hero(hero_path_dropped)
						if hero_from_data != hero_dropped:
							rank_box.set_skills(Data.get_empty_skills(), hero_path_dropped)
						else:
							rank_box.set_skills(rank_box.get_skills(), hero_path_dropped)
					
					update_heroes_in_data()
		)
		
		for skill_draggable in rank_box.skills:
			skill_draggable.item_dropped.connect(
					func(_drop_info: Variant):
						update_heroes_in_data()
			)
			skill_draggable.info_requested.connect(
					func(data: Variant):
						if data is Dictionary:
							if data["hero_path_assigned"] == HeroesPaths.Enum.NONE or data["skill"] == -1:
								notification_panel.hide()
							else:
								notification_panel.show_skill(data["hero_path_assigned"], data["skill"])
						else:
							notification_panel.hide()
			)
	
	flame_draggable.item_dropped.connect(
			func(_drop_info: Variant):
				update_heroes_in_data()
	)
	flame_draggable.info_requested.connect(
			func(info: Variant):
				if info == FlameDraggable.Flames.NONE:
					notification_panel.hide()
				else:
					notification_panel.show_flame(info)
	)
	game_level_draggable.item_dropped.connect(
			func(_drop_info: Variant):
				update_heroes_in_data()
	)
	game_level_draggable.info_requested.connect(
			func(info: Variant):
				if info == GameLevelDraggable.GameLevels.NONE:
					notification_panel.hide()
				else:
					notification_panel.show_game_level(info)
	)
	pet_draggable.item_dropped.connect(
			func(_drop_info: Variant):
				update_heroes_in_data()
	)
	pet_draggable.info_requested.connect(
			func(info: Variant):
				if info == PetDraggable.Pets.NONE:
					notification_panel.hide()
				else:
					notification_panel.show_pet(info)
	)
	
	popup_panel.save_requested.connect(
			func(squad_name: String):
				print("Saved squad: %s" % squad_name)
				Data.current_squad["squad_name"] = squad_name
				var user_data := SaveLoad.load_data()
				user_data[squad_name] = Data.current_squad.duplicate(true)
				SaveLoad.save_data(user_data)
				
				await get_tree().process_frame
				if tab_bar.current_tab == 3:
					saved_squads_menu.visibility_changed.emit()
				else:
					tab_bar.current_tab = 3
					tab_container.current_tab = 3
	)
	
	Data.all_skills_comments.viewport = viewport
	
	if OS.has_feature("web") and Engine.has_singleton("JavaScriptBridge"):
		var query := JavaScriptBridge.eval("window.location.search", true) as String
		if query == null or query.is_empty():
			await get_tree().create_timer(0.2).timeout
			query = JavaScriptBridge.eval("window.location.hash", true) as String
		
		if query != null and not query.is_empty() and query.begins_with("?squad="):
			var squad_code := query.replace("?squad=", "")
			paste_squad_data(squad_code)
			print_debug("Loaded squad from URL parameter: %s" % query)


func _on_resized() -> void:
	var tab_container_size := 600
	split_container.split_offset = int(self.size.x) - tab_container_size


## Updates [member Data.current_squad], reading hero paths, skills etc.
func update_heroes_in_data():
	for rank_box: RankBox in rank_boxes.values():
		var rank := str(rank_box.rank)
		Data.current_squad[rank]["hero_path"] = rank_box.hero_path_draggable.get_hero_path()
		Data.current_squad[rank]["skills"] = rank_box.get_skills()
	
	Data.current_squad["flame"] = flame_draggable.get_flame()
	Data.current_squad["game_level"] = game_level_draggable.get_game_level()
	Data.current_squad["pet"] = pet_draggable.get_pet()
	skills_menu.visibility_changed.emit()
	bottom_box.update()


func paste_squad_data(data: Variant):
	var squad_data: Dictionary = {}
	if data is String or data is Dictionary:
		if data is String:
			squad_data = SquadCode.decode_squad(data)
		elif data is Dictionary:
			squad_data = data as Dictionary
		
	if squad_data.is_empty():
		notification_panel.show_message("Failed to decode!")
		return
	
	for rank_box: RankBox in rank_boxes.values():
		var key := str(rank_box.rank)
		var hp := squad_data[key]["hero_path"] as HeroesPaths.Enum
		var skills: Array[int] = []
		skills.assign(squad_data[key]["skills"])
		rank_box.hero_path_draggable.set_hero_path(hp)
		rank_box.set_skills(skills, hp)
	
	flame_draggable.set_flame(squad_data.get("flame", FlameDraggable.Flames.NONE))
	game_level_draggable.set_game_level(squad_data.get("game_level", GameLevelDraggable.GameLevels.NONE))
	pet_draggable.set_pet(squad_data.get("pet", PetDraggable.Pets.NONE))
	Data.current_squad["squad_name"] = squad_data["squad_name"]
	update_heroes_in_data()
