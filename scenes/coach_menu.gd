class_name CoachMenu
extends MarginContainer

@export var main_scene: MainScene
@export_group("Required Children")
@export var flames_grid: GridContainer
@export var acts_grid: GridContainer


func _ready() -> void:
	for node in flames_grid.get_children():
		node.queue_free()
	for node in acts_grid.get_children():
		node.queue_free()
	
	for value in FlameDraggable.Flames.values():
		if value == FlameDraggable.Flames.NONE:
			continue
		
		var flame := FlameDraggable.create(value)
		flame.info_requested.connect(
				func(flame: FlameDraggable.Flames):
					if flame == FlameDraggable.Flames.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_flame(flame)
		)
		flames_grid.add_child(flame)
	
	for value in ActDraggable.Acts.values():
		if value == ActDraggable.Acts.NONE:
			continue
		
		var act := ActDraggable.create(value)
		act.info_requested.connect(
				func(act: ActDraggable.Acts):
					if act == ActDraggable.Acts.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_act(act)
		)
		acts_grid.add_child(act)
