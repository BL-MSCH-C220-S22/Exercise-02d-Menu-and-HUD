extends Node

func _ready():
	randomize()

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		get_tree().quit()
