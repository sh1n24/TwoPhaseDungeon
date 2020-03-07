extends KinematicBody2D

export (bool) var is_light := true
export var step = 16

onready var sprite = $AnimatedSprite
onready var left = $Left
onready var down = $Down
onready var right = $Right
onready var up = $Up
onready var in_wall = $InWall
onready var tween = $Tween
onready var audio = $Audio

var candle : Node
var dead = false

func _ready():
	update_display()

func update_display():
	if is_light:
		sprite.play("light")
	else:
		sprite.play("dark")

func _physics_process(delta):
	if tween.is_active() or dead:
		return
	if Input.is_action_just_pressed("ui_left"):
		_handle_move(left, -1, 0)
	elif Input.is_action_just_pressed("ui_right"):
		_handle_move(right, 1, 0)
	elif Input.is_action_just_pressed("ui_down"):
		_handle_move(down, 0, 1)
	elif Input.is_action_just_pressed("ui_up"):
		_handle_move(up, 0, -1)
	if candle:
		if Input.is_action_just_pressed("ui_select"):
			candle.turn()

func _handle_move(var ray: RayCast2D, var x, var y):
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider = ray.get_collider()
	else:
		var target = Vector2(global_position.x + x * step, global_position.y + y * step)
		audio.pitch_scale = rand_range(0.8, 1.1)
		audio.play()
		tween.interpolate_property(self, "global_position", self.global_position, target, .1)
		tween.start()

func _on_CastArea_body_entered(body):
	if body.is_in_group("Candle"):
		candle = body

func _on_CastArea_body_exited(body):
	if body.is_in_group("Candle"):
		candle = null

func _on_world_switched(var is_light):
	self.is_light = is_light
	update_display()

func _die():
	dead = true
	if is_light:
		sprite.play("light_die")
	else:
		sprite.play("dark_die")
	yield(get_tree().create_timer(1), "timeout")
	Global.reload()

