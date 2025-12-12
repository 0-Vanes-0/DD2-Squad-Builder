class_name MenuTabBar
extends TabBar

@export var tab_container: TabContainer


func _ready() -> void:
	assert(tab_container)


func _on_tab_bar_tab_selected(tab: int) -> void:
	tab_container.current_tab = tab
