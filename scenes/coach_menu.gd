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
				func(flame: FlameDraggable.Flames):
					if flame == FlameDraggable.Flames.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_flame(flame)
		)
		flames_grid.add_child(flame_draggable)
	
	for value in ActDraggable.Acts.values():
		if value == ActDraggable.Acts.NONE:
			continue
		
		var act_draggable := ActDraggable.create(value)
		act_draggable.info_requested.connect(
				func(act: ActDraggable.Acts):
					if act == ActDraggable.Acts.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_act(act)
		)
		acts_grid.add_child(act_draggable)
	
	for value in PetDraggable.Pets.values():
		if value == PetDraggable.Pets.NONE:
			continue
		
		var pet_draggable := PetDraggable.create(value)
		pet_draggable.info_requested.connect(
				func(pet: PetDraggable.Pets):
					if pet == PetDraggable.Pets.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_pet(pet)
		)
		pets_grid.add_child(pet_draggable)
