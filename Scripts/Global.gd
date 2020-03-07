extends Node

var levels = [
	"res://Scenes/Level0.tscn",
	"res://Scenes/Level1.tscn",
	"res://Scenes/Level2.tscn",
	"res://Scenes/Level3.tscn",
	"res://Scenes/Level4.tscn",
	"res://Scenes/Levelf.tscn",
]

var current = 0

func _physics_process(delta):
	if Input.is_action_just_pressed("reset"):
		reload()

func reload():
	get_tree().change_scene(levels[current])

func next_level():
	current += 1
	if current > levels.size() - 1:
		current = 0
	get_tree().change_scene(levels[current])
