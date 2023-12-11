extends Control


@onready var tab_container = %TabContainer
@onready var focus_timer = %FocusTimer
@onready var break_timer = %BreakTimer
@onready var long_break_timer = %LongBreakTimer
@onready var background_rect = %BackgroundRect


var current_tab_id: int


func map_tab_index_to_timer(tab_id: int) -> Control:
	match tab_id:
		0:
			return focus_timer
		1:
			return break_timer
		2:
			return long_break_timer
		_:
			push_error('Invalid tab_id supplied: ', tab_id)
			return null


func update_background_rectangle(tab_id: int):
	match tab_id:
		0:
			background_rect.color = GlobalVariables.BACKGROUND_FOCUS
		1:
			background_rect.color = GlobalVariables.BACKGROUND_BREAK
		2:
			background_rect.color = GlobalVariables.BACKGROUND_LONG_BREAK
		_:
			pass


func switch_tab(new_tab_id: int):
	# handle timer stop
	if current_tab_id != null:
		var current_timer = map_tab_index_to_timer(current_tab_id)
		if current_timer.timer.is_stopped() == false:
			current_timer.stop_timer()
	
	# programmatically jump to next tab
	tab_container.current_tab = new_tab_id
	current_tab_id = new_tab_id
	update_background_rectangle(new_tab_id)

	# refresh the new timer
	var new_timer = map_tab_index_to_timer(current_tab_id)
	new_timer.initialize_timer()


func _on_tab_container_tab_changed(new_tab_id):
	switch_tab(new_tab_id)


func _on_timer_skipped():
	# decide the next tab id
	var new_tab_id: int
	if current_tab_id == null:
		new_tab_id = GlobalVariables.TIMER_MODE.BREAK
	else:
		new_tab_id = (current_tab_id + 1) %  3
	
	switch_tab(new_tab_id)

