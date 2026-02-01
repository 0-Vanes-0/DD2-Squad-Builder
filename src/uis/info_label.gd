class_name InfoLabel
extends RichTextLabel

const URLS := {
	"issues": "https://github.com/0-Vanes-0/DD2-Squad-Builder/issues",
	"Steam": "https://store.steampowered.com/app/1940340/Darkest_Dungeon_II/",
	"Godot": "https://godotengine.org/",
	"wiki": "https://darkestdungeon.wiki.gg/wiki/Heroes_(Darkest_Dungeon_II)",
}
@export var notification_panel: NotificationPanel
var _is_mouse_inside := false


func _ready() -> void:
	assert(notification_panel)
	self.text = self.text % ProjectSettings.get_setting("application/config/version")


func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(URLS[str(meta)])


func _on_meta_hover_started(meta: Variant) -> void:
	if _is_mouse_inside:
		notification_panel.show_message(URLS[str(meta)], true)


func _on_meta_hover_ended(_meta: Variant) -> void:
	notification_panel.hide()


func _on_mouse_entered() -> void:
	_is_mouse_inside = true


func _on_mouse_exited() -> void:
	_is_mouse_inside = false
	notification_panel.hide()
