extends Node2D

signal world_switched

export (bool) var is_light := true
export (Color) var light_background := Color("#472d3c")
export (Color) var dark_background := Color("#000000")

onready var light = $LightMap
onready var dark = $DarkMap

func _ready():
	_switch_world(self.is_light)

func _switch_world(var is_light):
	var node_enable : TileMap
	var node_disable : TileMap
	self.is_light = is_light
	if is_light:
		node_enable = light
		node_disable = dark
		VisualServer.set_default_clear_color(light_background)
	else:
		node_enable = dark
		node_disable = light
		VisualServer.set_default_clear_color(dark_background)
	node_disable.hide()
	node_disable.set_collision_layer_bit(0, false)
	node_disable.set_collision_mask_bit(0, false)
	node_enable.show()
	node_enable.set_collision_layer_bit(0, true)
	node_enable.set_collision_mask_bit(0, true)
	emit_signal("world_switched", is_light)

func _on_candle_turned():
	var nodes = get_tree().get_nodes_in_group("Candle")
	var all_off = true
	for node in nodes:
		if node.is_on:
			all_off = false
			break;
	if all_off and is_light:
		_switch_world(false)
	elif not all_off and not is_light:
		_switch_world(true)
