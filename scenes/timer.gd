extends Control

@export var wait_time_in_seconds: int

func initialize_timer():
	%Timer.set_wait_time(wait_time_in_seconds)

func start_timer():
	%Timer.start()

func stop_timer():
	%Timer.stop()

func _ready():
	initialize_timer()
	start_timer()

func _physics_process(_delta):
	var time_left_in_second: float = %Timer.get_time_left()
	
	var minutes_left = get_minutes_left(time_left_in_second)
	var second_left = get_seconds_left(time_left_in_second)
		
	update_minute_label(minutes_left)
	update_second_label(second_left)

func get_minutes_left(time_left: float) -> int:
	@warning_ignore("integer_division")
	return int(time_left) / 60

func get_seconds_left(time_left: float) -> int:
	return int(time_left) % 60

func update_minute_label(minutes: float):
	%LabelMinute.text = GlobalUtilities.decorate_zero_padding(minutes)

func update_second_label(seconds: float):
	%LabelSecond.text = GlobalUtilities.decorate_zero_padding(seconds)

func _on_button_start_pressed():
	start_timer()

func _on_button_skip_pressed():
	print('should skip to next state')
