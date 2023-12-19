extends Control


signal timer_skipped


@export var timer_mode: GlobalVariables.TIMER_MODE = GlobalVariables.TIMER_MODE.FOCUS
@onready var timer = %Timer


var wait_time_in_minutes: int
var wait_time_in_seconds: int
var is_started: bool = false
var is_paused: bool:
	set(value):
		is_paused = value
		%Timer.set_paused(is_paused)



func initialize_timer():
	print('initializing timer')
	match timer_mode:
		GlobalVariables.TIMER_MODE.FOCUS:
			wait_time_in_minutes = GlobalVariables.FOCUS_TIME_IN_MINUTE
		GlobalVariables.TIMER_MODE.BREAK:
			wait_time_in_minutes = GlobalVariables.BREAK_TIME_IN_MINUTE
		GlobalVariables.TIMER_MODE.LONG_BREAK:
			wait_time_in_minutes = GlobalVariables.LONG_BREAK_TIME_IN_MINUTE
	
	wait_time_in_seconds = wait_time_in_minutes * 60
	is_started = false
	is_paused = false

	# https://docs.godotengine.org/en/4.2/classes/class_timer.html#enum-timer-timerprocesscallback
	%Timer.set_timer_process_callback(0)
	%Timer.set_wait_time(wait_time_in_seconds)


func update_ui():
	# Start/Pause Button
	
	if is_started == false or is_paused == true:
		%ButtonStart.text = str('Start')
	else:
		%ButtonStart.text = str('Pause')
	
	# Timer label
	var time_left_in_second: float = %Timer.get_time_left()

	# on every start,the time left would be 0 when timer is paused
	# if so, then use the global time left from upper hierarchy
	if time_left_in_second == 0 and wait_time_in_seconds != 0:
		time_left_in_second = wait_time_in_seconds

	var minutes_left = get_minutes_left(time_left_in_second)
	var second_left = get_seconds_left(time_left_in_second)
	update_minute_label(minutes_left)
	update_second_label(second_left)


func start_timer():
	%Timer.start()
	is_started = true


func pause_timer():
	is_paused = not is_paused


func stop_timer():
	%Timer.stop()


func get_timer_time_left() -> int:
	return %Timer.get_time_left()


func get_minutes_left(time_left: float) -> int:
	@warning_ignore("integer_division")
	return int(time_left) / 60


func get_seconds_left(time_left: float) -> int:
	return int(time_left) % 60


func update_minute_label(minutes: float):
	%LabelMinute.text = GlobalUtilities.decorate_zero_padding(minutes)


func update_second_label(seconds: float):
	%LabelSecond.text = GlobalUtilities.decorate_zero_padding(seconds)


func _ready():
	initialize_timer()
	update_ui()


func _physics_process(_delta):	
	update_ui()


func _on_button_start_pressed():
	if is_started == false:
		start_timer()
	else:
		pause_timer()
	
	GlobalAudioPlayer.play_click()


func _on_button_skip_pressed():
	# emit this signal to be caught by gomodoro.gd
	timer_skipped.emit()
	
	GlobalAudioPlayer.play_click()

