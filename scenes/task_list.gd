extends Control


@onready var task_container = %TaskContainer


func _ready():
	# connect all children's move signal to self
	for children in task_container.get_children():
		children.move_up.connect(move_task_up)
		children.move_down.connect(move_task_down)
		# TODO: for each added task, should also being connected to this signal


func move_task_up(node: Node, index: int):
	var next_index = index - 1
	task_container.move_child(node, next_index)


func move_task_down(node: Node, index: int):
	var task_size = task_container.get_child_count()
	var next_index = (index + 1) % task_size
	task_container.move_child(node, next_index)

