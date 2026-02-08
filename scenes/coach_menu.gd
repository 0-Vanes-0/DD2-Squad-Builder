class_name CoachMenu
extends MarginContainer

@export var main_scene: MainScene
@export_group("Required Children")
@export var flames_grid: GridContainer
@export var acts_grid: GridContainer
@export var pets_grid: GridContainer


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
			
		var act_draggable := GameLevelDraggable.create(value)
		act_draggable.info_requested.connect(
				func(main_value: Variant):
					if main_value == GameLevelDraggable.GameLevels.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_game_level(main_value)
		)
		acts_grid.add_child(act_draggable)
	
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
