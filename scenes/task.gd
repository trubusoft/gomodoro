extends Control


signal toggle_check(toggled_on: bool)


@onready var task = $"."
@onready var panel = %Panel
@onready var margin_container = %MarginContainer
@onready var check_box = %CheckBox


var grow_size = 100


func toggle_expand_panel(toggled_on: bool):
	if toggled_on:
		task.custom_minimum_size.y += grow_size
		panel.size.y += grow_size
	else:
		task.custom_minimum_size.y -= grow_size
		panel.size.y -= grow_size


func _ready():
	pass


func _process(_delta):
	pass


func _on_check_box_toggled(toggled_on):
	toggle_check.emit(toggled_on)
	toggle_expand_panel(toggled_on)
