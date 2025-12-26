class_name BottomBox
extends VBoxContainer

@export_group("Required Children")
@export var total_properties_label: PropertiesLabel
@export var grid_container: GridContainer
@export var rank_1_properties_label: PropertiesLabel
@export var rank_2_properties_label: PropertiesLabel
@export var rank_3_properties_label: PropertiesLabel
@export var rank_4_properties_label: PropertiesLabel


func _ready() -> void:
	assert(total_properties_label and grid_container and rank_1_properties_label and rank_2_properties_label and rank_3_properties_label and rank_4_properties_label)
	total_properties_label.visibility_changed.connect( func(): if total_properties_label.visible: total_properties_label.update_skills_props() )
	rank_1_properties_label.visibility_changed.connect( func(): if rank_1_properties_label.visible: rank_1_properties_label.update_skills_props(["1"]) )
	rank_2_properties_label.visibility_changed.connect( func(): if rank_2_properties_label.visible: rank_2_properties_label.update_skills_props(["2"]) )
	rank_3_properties_label.visibility_changed.connect( func(): if rank_3_properties_label.visible: rank_3_properties_label.update_skills_props(["3"]) )
	rank_4_properties_label.visibility_changed.connect( func(): if rank_4_properties_label.visible: rank_4_properties_label.update_skills_props(["4"]) )


func _on_switch_button_pressed() -> void:
	if total_properties_label.visible:
		total_properties_label.hide()
		grid_container.show()
	else:
		grid_container.hide()
		total_properties_label.show()


func update():
	total_properties_label.visibility_changed.emit()
	rank_1_properties_label.visibility_changed.emit()
	rank_2_properties_label.visibility_changed.emit()
	rank_3_properties_label.visibility_changed.emit()
	rank_4_properties_label.visibility_changed.emit()
