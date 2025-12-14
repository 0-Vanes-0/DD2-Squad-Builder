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
@export var skills_menu: SkillsMenu
@export var notification_panel: NotificationPanel
@export var popup_panel: MyPopupPanel


func _ready() -> void:
	assert(tab_bar and tab_container and split_container and popup_panel and skills_menu and notification_panel and popup_panel)
	for rank_box in rank_boxes.values():
		assert(rank_box)
	tab_bar.current_tab = 0
	tab_container.current_tab = 0
	
	for rank_box: RankBox in rank_boxes.values():
		rank_box.hero_path_draggable.is_unique = (
				func(hero_path: Data.HeroesPaths) -> bool:
					var hero := Data.hero_path_to_hero(hero_path)
					var rank_box_hero := Data.hero_path_to_hero(rank_box.hero_path_draggable.hero_path)
					return hero == rank_box_hero or rank_boxes.values().all(
							func(rb: RankBox) -> bool:
								var rb_hero := Data.hero_path_to_hero(rb.hero_path_draggable.hero_path)
								return hero != rb_hero 
					)
		)

		rank_box.hero_path_draggable.hero_dropped.connect(
				func(from_rank: int):
					# If dropped from another rank box:
					if from_rank > 0:
						if from_rank != rank_box.rank:
							# NOTE: Hero paths are already changed!!!
							var temp_skills := rank_boxes[from_rank].get_skills()
							rank_boxes[from_rank].set_skills(rank_box.get_skills(), rank_boxes[from_rank].hero_path_draggable.hero_path)
							rank_box.set_skills(temp_skills, rank_box.hero_path_draggable.hero_path)
							
							for skill in rank_box.skills:
								skill.show()
							for skill in rank_boxes[from_rank].skills:
								skill.visible = rank_boxes[from_rank].hero_path_draggable.hero_path != Data.HeroesPaths.NONE
					
					# If dropped from heroes table:
					else:
						var hero_path_from_data := Data.dict[rank_box.rank]["hero_path"] as Data.HeroesPaths
						var hero_path_dropped := rank_box.hero_path_draggable.hero_path
						var hero_from_data := Data.hero_path_to_hero(hero_path_from_data)
						var hero_dropped := Data.hero_path_to_hero(hero_path_dropped)
						if hero_from_data != hero_dropped:
							rank_box.set_skills([-1, -1, -1, -1, -1], hero_path_dropped)
						else:
							rank_box.set_skills(rank_box.get_skills(), hero_path_dropped)
						
						for skill in rank_box.skills:
							skill.show()
					
					update_heroes_in_data()
		)

		for skill_draggable in rank_box.skills:
			skill_draggable.skill_dropped.connect( func(): update_heroes_in_data() )
	
	popup_panel.save_requested.connect(
			func(squad_name: String):
				print("Saved squad: %s" % squad_name)
				Data.dict["squad_name"] = squad_name
				tab_bar.current_tab = 2
				tab_container.current_tab = 2
	) # TODO: Implement save squad.


func _on_resized() -> void:
	var tab_container_size := 600
	split_container.split_offset = int(self.size.x) - tab_container_size


func update_heroes_in_data():
	for rank_box: RankBox in rank_boxes.values():
		var rank := rank_box.rank
		Data.dict[rank]["hero_path"] = rank_box.hero_path_draggable.hero_path
		Data.dict[rank]["skills"] = rank_box.get_skills()
	
	skills_menu.visibility_changed.emit()
