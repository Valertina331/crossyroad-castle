extends Node2D

@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = 5
	timer.start()



func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
