extends Node2D

export (Array) var platforms

const MIN_INTERVAL = 100
const MAX_INTERVAL = 250
const INITIAL_PLATFORMS_COUNT = 40

var current_max_interval
var current_min_interval
var last_spawn_height
var screen_size

func _ready():
	get_viewport_rect()
	last_spawn_height = get_viewport().get_visible_rect().size.y
	current_max_interval = MIN_INTERVAL
	current_min_interval = MIN_INTERVAL
	screen_size = get_viewport().get_visible_rect().size.x
	_spawn_first_platforms()

func _spawn_first_platforms():
	var index
	var new_platform

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
