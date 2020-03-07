extends StaticBody2D

export (bool) var is_light := true
export (bool) var is_on := true

signal candle_turned

onready var sprite = $AnimatedSprite
onready var audio = $Audio

func _ready():
	update_display()
	
func turn():
	is_on = !is_on
	audio.pitch_scale = rand_range(0.8, 1.1)
	audio.play()
	update_display()
	emit_signal("candle_turned")

func update_display():
	if is_light:
		if is_on:
			sprite.play("light_on")
		else:
			sprite.play("light_off")
	else:
		sprite.play("dark")

func _on_world_switched(var is_light):
	self.is_light = is_light
	update_display()
