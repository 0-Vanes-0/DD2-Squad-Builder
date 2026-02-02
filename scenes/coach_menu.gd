class_name CoachMenu
extends MarginContainer

@export var main_scene: MainScene
@export_group("Required Children")
@export var flames_grid: GridContainer


func _ready() -> void:
	assert(main_scene and flames_grid)
	
	for node in flames_grid.get_children():
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
