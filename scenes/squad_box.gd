class_name SquadBox
extends VBoxContainer

@export_group("Required Children")
@export var squad_name_label: Label
@export var rank1_hpd: HeroPathDraggable
@export var rank2_hpd: HeroPathDraggable
@export var rank3_hpd: HeroPathDraggable
@export var rank4_hpd: HeroPathDraggable

var main_scene: MainScene
var squad_data: Dictionary = {}


static func create(dict: Dictionary) -> SquadBox:
	var squad_box := preload("res://scenes/squad_box.tscn").instantiate() as SquadBox # For some reason can't create @export in Data
	squad_box.squad_data = dict.duplicate(true)
	squad_box.squad_name_label.text = dict["squad_name"] as String
	squad_box.rank1_hpd.texture = Data.heroes_textures[dict["1"]["hero_path"] as HeroesPaths.Enum]
	squad_box.rank2_hpd.texture = Data.heroes_textures[dict["2"]["hero_path"] as HeroesPaths.Enum]
	squad_box.rank3_hpd.texture = Data.heroes_textures[dict["3"]["hero_path"] as HeroesPaths.Enum]
	squad_box.rank4_hpd.texture = Data.heroes_textures[dict["4"]["hero_path"] as HeroesPaths.Enum]
	return squad_box


func _ready() -> void:
	assert(squad_name_label and rank1_hpd and rank2_hpd and rank3_hpd and rank4_hpd)
	rank1_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank2_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank3_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rank4_hpd.mouse_filter = Control.MOUSE_FILTER_IGNORE

	main_scene = get_tree().current_scene as MainScene
	assert(main_scene)
	main_scene.popup_panel.rename_requested.connect(
			func(from_squad_name: String, to_squad_name: String):
				if from_squad_name != to_squad_name:
					print("Renamed squad %s to: %s" % [from_squad_name, to_squad_name])
					squad_name_label.text = to_squad_name

					var user_data := SaveLoad.load_data()
					user_data[to_squad_name] = squad_data.duplicate(true)
					user_data[to_squad_name]["squad_name"] = to_squad_name
					assert(user_data.erase(from_squad_name))
					SaveLoad.save_data(user_data)
	)
	main_scene.popup_panel.delete_requested.connect(
			func(squad_name: String):
				print("Deleted squad: %s" % squad_name)
				var user_data := SaveLoad.load_data()
				user_data.erase(squad_name)
				SaveLoad.save_data(user_data)
				
				self.queue_free()
	)


func _on_paste_button_pressed() -> void:
	main_scene.paste_squad_data(squad_data)


func _on_copy_button_pressed() -> void:
	var code := SquadCode.encode_squad(squad_data)
	DisplayServer.clipboard_set(code)
	main_scene.notification_panel.show_message("Copied!")


func _on_rename_button_pressed() -> void:
	main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.RENAME_SQUAD, squad_name_label.text)


func _on_delete_button_pressed() -> void:
	main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.DELETE_SQUAD, squad_name_label.text)
