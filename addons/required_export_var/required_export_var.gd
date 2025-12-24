@tool
class_name RequiredExportVar
extends EditorPlugin

var _code_edit: CodeEdit


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	var script_editor := get_editor_interface().get_script_editor()
	script_editor.editor_script_changed.connect(_on_editor_script_changed)
	_hook_current_codeedit()


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


#region CodeEdit code
func _on_editor_script_changed(_script: Script) -> void:
	_hook_current_codeedit()


func _hook_current_codeedit() -> void:
	_unhook_codeedit()
	var script_editor := get_editor_interface().get_script_editor()
	var script_editor_base := script_editor.get_current_editor()
	if script_editor_base == null: 
		print_debug("script_editor_base is null")
		return
	
	_code_edit = script_editor_base.get_base_editor() as CodeEdit # ← the text editor widget
	if _code_edit == null:
		print_debug("_code_edit is null")
		return
	
	# Forward drag/drop to us. (3 callables: get_drag_data, can_drop, drop)
	_code_edit.set_drag_forwarding(
			_fw_get_drag_data,
			_fw_can_drop_data,
			_fw_drop_data
	)


func _unhook_codeedit() -> void:
	if _code_edit:
		# Clear forwarding so default behavior is restored.
		_code_edit.set_drag_forwarding(Callable(), Callable(), Callable())
		_code_edit = null
#endregion

#region Can drop
func _fw_get_drag_data(_pos: Vector2) -> Variant:
	# We don't start drags from the code editor; return null.
	return null


func _fw_can_drop_data(_pos: Vector2, data: Variant) -> bool:
	# Accept only Scene-dock node drops + Ctrl held. Otherwise, let CodeEdit handle it.
	if typeof(data) != TYPE_DICTIONARY: 
		print_debug("data is not Dictionary")
		return false
	
	if !"type" in data or data.type != "nodes":
		print_debug("data doesn't have \"type\": \"nodes\" entry")
		return false
	return true
#endregion

#region Drop data
func _fw_drop_data(pos: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY: 
		print_debug("data is not Dictionary")
		return
	
	var paths: Array[NodePath]
	paths.assign(data.get("nodes", []))
	if paths.is_empty():
		print_debug("No paths found")
		return

	var scene_root := get_editor_interface().get_edited_scene_root()
	if scene_root == null:
		print_debug("scene_root is null")
		return
	
	var insert_coords := _code_edit.get_line_column_at_pos(pos)
	_code_edit.set_caret_line(insert_coords.y)
	_code_edit.set_caret_column(insert_coords.x)
	
	if Input.is_key_pressed(KEY_CTRL):
		var export_block := ""
		var export_lines: PackedStringArray = []
		var assert_vars: PackedStringArray = []
		
		if _code_edit.text.find("@export_group(\"Required Children\")") == -1:
			export_block += "\n@export_group(\"Required Children\")\n"
		
		for path in paths:
			var node := scene_root.get_node_or_null(path)
			var type_name := _get_node_class_name(node)
			var var_name := _make_var_name(path)
			export_lines.append("@export var %s: %s" % [var_name, type_name])
			assert_vars.append(str(var_name))

		export_block += "\n".join(export_lines) + "\n"
		# Insert variable declarations at caret:
		_code_edit.insert_text_at_caret(export_block)

		# Ensure/patch a _ready() and append the assignments.
		_insert_assert_vars(assert_vars)
	
	else: # Preserve old behavior without CTRL
		var dollar_paths: PackedStringArray = []
		for path in paths:
			dollar_paths.append("$" + _absolute_to_relative_path(path))
		
		# Insert variable declarations at caret:
		_code_edit.insert_text_at_caret(", ".join(dollar_paths))
#endregion

#region Add assert vars
func _insert_assert_vars(assert_vars: PackedStringArray) -> void:
	var ready_line_index := -1

	for i in _code_edit.get_line_count():
		var line_text := _code_edit.get_line(i)
		if line_text.strip_edges().begins_with("func _ready("):
			ready_line_index = i
			break

	if ready_line_index == -1:
		_code_edit.set_caret_line(_code_edit.get_line_count())
		_code_edit.set_caret_column(0)
		_code_edit.insert_text_at_caret("\n\nfunc _ready() -> void:\n")
		ready_line_index = _code_edit.get_line_count()
	
	_code_edit.set_caret_line(ready_line_index + 1)
	var first_line := _code_edit.get_line(ready_line_index + 1)
	if not first_line.begins_with("\tassert("):
		_code_edit.set_caret_column(0)
		var assert_expression := "\tassert(" + " and ".join(assert_vars) + ")\n"
		_code_edit.insert_text_at_caret(assert_expression)
	else:
		_code_edit.set_caret_column(first_line.length() - 1)
		var additional_assert_expression := " and " + " and ".join(assert_vars)
		_code_edit.insert_text_at_caret(additional_assert_expression)
	
	_code_edit.set_caret_line(ready_line_index - 2)
	_code_edit.set_caret_column(0)
#endregion

#region Helpers
func _make_var_name(path: NodePath) -> String:
	# simple lower_snake conversion; ensure uniqueness within the buffer
	var name := path.get_name(path.get_name_count() - 1).to_snake_case()
	var text := _code_edit.text
	if not _identifier_exists(text, name):
		return name
	
	var idx := 2
	while _identifier_exists(text, "%s_%d" % [name, idx]):
		idx += 1
	return "%s_%d" % [name, idx]


func _identifier_exists(text: String, id: String) -> bool:
	return (text.findn('@export var ' + id) != -1) or (text.findn('var ' + id) != -1)


func _get_node_class_name(node: Node) -> String:
	var script := node.get_script() as Script
	if script == null or script.get_global_name().is_empty():
		return node.get_class()
	else:
		return script.get_global_name()


func _absolute_to_relative_path(path: NodePath) -> String:
	var ann_idx := str(path).rfind("@")
	var first_slash_idx := str(path).find("/", ann_idx)
	var second_slash_idx := str(path).find("/", first_slash_idx + 1)
	var relative_path := str(path).substr(second_slash_idx + 1)
	return relative_path
#endregion
