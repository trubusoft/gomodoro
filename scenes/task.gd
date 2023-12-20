extends Control


signal toggle_check(toggled_on: bool)


@onready var task = $"."
@onready var panel = %Panel
@onready var margin_container = %MarginContainer
@onready var check_box = %CheckBox
@onready var task_description = %TaskDescription
@onready var content_icon = $Panel/MarginContainer/VBoxContainer/HBoxContainer/ContentIcon


var is_panel_expanded = false
var grow_size = 200


func toggle_expand_panel():
	if is_panel_expanded == false:
		is_panel_expanded = true
		task.custom_minimum_size.y += grow_size
		panel.size.y += grow_size
		task_description.visible = true
		task_description.custom_minimum_size.y = grow_size # deliberately setto grow_size
	elif is_panel_expanded == true:
		is_panel_expanded = false
		task.custom_minimum_size.y -= grow_size
		panel.size.y -= grow_size
		task_description.visible = false


func is_click(event) -> bool:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == true:
		return true
	return false


func _on_check_box_toggled(toggled_on):
	toggle_check.emit(toggled_on)


func _on_panel_gui_input(event):
	if is_click(event):
		toggle_expand_panel()


func _on_task_description_text_changed():
	var new_text_description_length = len(task_description.text.strip_escapes())
	if new_text_description_length > 5:
		content_icon.visible = true
	else:
		content_icon.visible = false

