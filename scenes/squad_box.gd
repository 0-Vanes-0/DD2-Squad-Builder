class_name SquadBox
extends VBoxContainer

@export_group("Required Children")
@export var squad_name_label: Label
@export var rank1_hpd: HeroPathDraggable
@export var rank2_hpd: HeroPathDraggable
@export var rank3_hpd: HeroPathDraggable
@export var rank4_hpd: HeroPathDraggable

var main_scene: MainScene


func _ready() -> void:
	assert(squad_name_label and rank1_hpd and rank2_hpd and rank3_hpd and rank4_hpd)
	rank1_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank2_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank3_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank4_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE

	main_scene = get_tree().current_scene as MainScene
	assert(main_scene)
	main_scene.popup_panel.rename_requested.connect(
			func(squad_name: String):
				print("Renamed squad to: %s" % squad_name)
				squad_name_label.text = squad_name
	)
	main_scene.popup_panel.delete_requested.connect(
			func(squad_name: String):
				print("Deleted squad: %s" % squad_name)
				self.queue_free()
	)


func _on_inspect_button_pressed() -> void:
	pass # TODO: Paste squad to main scene and to data (ranks, squad name)


func _on_copy_button_pressed() -> void:
	pass # TODO: Copy squad to clipboard


func _on_rename_button_pressed() -> void:
	main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.RENAME_SQUAD, squad_name_label.text)


func _on_delete_button_pressed() -> void:
	main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.DELETE_SQUAD, squad_name_label.text)
