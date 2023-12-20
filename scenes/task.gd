extends Control


signal toggle_check(toggled_on: bool)
signal move_up(node: Node, index: int)
signal move_down(node: Node, index: int)


@onready var task = $"."
@onready var panel = %Panel
@onready var margin_container = %MarginContainer
@onready var check_box = %CheckBox
@onready var task_name = %TaskName
@onready var task_description = %TaskDescription
@onready var content_icon = $Panel/MarginContainer/VBoxContainer/HBoxContainer/ContentIcon


var is_panel_expanded = false
var grow_size = 200

var is_being_pointed: bool = false
var is_being_dragged: bool = false
var drag_and_drop_upper_bound = -10 # -10 from 0px
var drag_and_drop_lower_bound = 50 # +10 from 40px (panel's minimum y size)


func expand_panel():
	is_panel_expanded = true
	task.custom_minimum_size.y += grow_size
	panel.size.y += grow_size
	task_description.visible = true
	task_description.custom_minimum_size.y = grow_size - 5 # deliberately set around grow_size


func shrink_panel():
	is_panel_expanded = false
	task.custom_minimum_size.y -= grow_size
	panel.size.y -= grow_size
	task_description.visible = false


func toggle_expand_panel():
	if is_panel_expanded == false:
		expand_panel()
	elif is_panel_expanded == true:
		shrink_panel()


func handle_drag_and_drop():
	is_being_dragged = true
	
	var local_mouse_y_position = get_local_mouse_position().y
	
	if local_mouse_y_position <= drag_and_drop_upper_bound and get_index() != 0:
		emit_signal('move_up', self, get_index())
	elif local_mouse_y_position >= drag_and_drop_lower_bound and get_index() != (get_parent().get_child_count() - 1):
		emit_signal('move_down', self, get_index())


func _on_check_box_toggled(toggled_on):
	toggle_check.emit(toggled_on)


func _on_panel_gui_input(_event):
	if Input.is_action_pressed("left_click") and not is_being_pointed:
		handle_drag_and_drop()

	if Input.is_action_just_released("left_click") and is_being_pointed and not is_being_dragged:
		toggle_expand_panel()
	
	# important to be placed here, so not to trigger when drag & drop is being released
	if Input.is_action_just_released("left_click") and is_being_dragged:
		is_being_dragged = false


func _on_task_name_gui_input(_event):
	if Input.is_action_just_released("left_click"):
		task_name.select_all()


func _on_task_description_text_changed():
	var new_text_description_length = len(task_description.text.strip_escapes())
	if new_text_description_length > 5:
		content_icon.visible = true
	else:
		content_icon.visible = false


func _on_panel_mouse_entered():
	is_being_pointed = true


func _on_panel_mouse_exited():
	is_being_pointed = false


func _on_move_up_button_pressed():
	emit_signal('move_up', self, get_index())


func _on_move_down_button_pressed():
	emit_signal('move_down', self, get_index())

