class_name BottomBox
extends VBoxContainer


@export_group("Required Children")
@export var properties_label: PropertiesLabel
@export var grid_container: GridContainer


func _ready() -> void:
	assert(properties_label and grid_container)


func _on_switch_button_pressed() -> void:
	pass # Replace with function body.
